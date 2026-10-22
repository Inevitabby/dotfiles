#!/bin/env bash

PASSWORD=$(timeout 5 secret-tool lookup service line) # SETUP: secret-tool store --label='LINE Password' service line
PORT=9222
EXTENSION_URL="chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html"

# 1. Launch Flatpak Chromium with remote debugging enabled
/usr/bin/flatpak run --branch=stable --arch=x86_64 \
  --command=/app/bin/chromium \
  --file-forwarding io.github.ungoogled_software.ungoogled_chromium \
  --password-store=basic \
  --remote-debugging-port=$PORT \
  --app=$EXTENSION_URL &

# 2. Poll until the CDP HTTP endpoint is responsive
while ! curl http://localhost:$PORT/json > /dev/null; do
    sleep 0.5
done
sleep 1

# 3. Poll until the specific LINE extension targets are loaded and extract ALL WebSocket URLs
WS_URLS=""
while [ -z "$WS_URLS" ] || [ "$WS_URLS" = "null" ]; do
    sleep 0.5
    WS_URLS=$(curl -s http://localhost:$PORT/json | /usr/bin/jq -r ".[] | select(.url | startswith(\"$EXTENSION_URL\")) | .webSocketDebuggerUrl")
done

# 4. JavaScript payload
JS_CODE="(function waitForElem() {
    let elem = document.querySelector(\"input[name='password']\");
    if (!elem) {
        setTimeout(waitForElem, 100);
        return;
    }
    // 1. Force focus
    elem.focus();
    // 2. Bypass framework state interception
    let nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    nativeInputValueSetter.call(elem, '${PASSWORD}');
    // 3. Dispatch input event
    elem.dispatchEvent(new Event('input', {bubbles: true}));
    // 4. Submit form
    elem.closest('form').dispatchEvent(new Event('submit', {bubbles: true, cancelable: true}));
    // 5. CSS Tweaks
    document.head.insertAdjacentHTML('beforeend', \`
        <svg>
            <filter id='custom-contrast'>
                <feColorMatrix type='matrix' values='
                    1.5  0    0    0   -0.0588
                    0    1.5  0    0   -0.0588
                    0    0    1.5  0   -0.0902
                    0    0    0    1    0' />
            </filter>
            <filter id='custom-contrast'>
                <feColorMatrix type='matrix' values='
                    0.666  0      0      0   0.0392
                    0      0.666  0      0   0.0392
                    0      0      0.666  0   0.0601
                    0      0      0      1   0' />
            </filter>
        </svg>
        <style>
            html {
                background: #1e1e2e !important;
                zoom: 1.25 !important;
            }
            body {
                filter: invert(100%) hue-rotate(180deg) url(#custom-contrast) !important;
            }
            img, video, canvas, picture {
                filter: invert(100%) hue-rotate(180deg) url(#inverse-contrast) !important;
            }
        </style>
    \`);
})();"
PAYLOAD=$(/usr/bin/jq -n -c --arg js "$JS_CODE" '{id: 1, method: "Runtime.evaluate", params: {expression: $js}}')

# 5. Send the payload
for url in $WS_URLS; do
    echo "$PAYLOAD" | timeout 2 /usr/bin/websocat "$url" &
done
wait
