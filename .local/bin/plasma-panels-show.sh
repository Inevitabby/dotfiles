#!/bin/env bash
qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript '
for (var i = 0; i < panelIds.length; i++) {
    var panel = panelById(panelIds[i]);
    if (panel) { panel.hiding = "none"; }
}'
