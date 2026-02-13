/*
 * Copyright (c) 2026 Ronin-CK
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import QtQuick

QtObject {
    id: root

    property var source: ({
    })
    readonly property color accent: _get("accent", "#cba6f7")
    readonly property color accentText: _get("accentText", "#11111b")
    readonly property real dimOpacity: _get("dimOpacity", 0.6)
    readonly property int borderRadius: _get("borderRadius", 10)
    readonly property int outlineThickness: _get("outlineThickness", 2)
    readonly property real bottomMargin: _get("bottomMargin", 60)
    readonly property color barBackground: _get("barBackground", Qt.rgba(0.15, 0.15, 0.15, 0.4))
    readonly property color barBorder: _get("barBorder", Qt.rgba(1, 1, 1, 0.15))
    readonly property color barText: _get("barText", "#AAFFFFFF")
    readonly property color barShadow: _get("barShadow", "#80000000")
    readonly property color toggleBackground: _get("toggleBackground", "white")
    readonly property color toggleShadow: _get("toggleShadow", "#80000000")
    readonly property color toggleEdit: _get("toggleEdit", "#1ABC9C")
    readonly property color toggleTemp: _get("toggleTemp", "#2C66D8")
    readonly property color shareConnected: _get("shareConnected", "#3498DB")
    readonly property color sharePending: _get("sharePending", "#95A5A6")
    readonly property color shareErrorIcon: _get("shareErrorIcon", "white")
    readonly property color shareErrorBackground: _get("shareErrorBackground", "#E74C3C")

    function _get(key, fallback) {
        let val = source[key];
        val = (val !== undefined && val !== null) ? val : fallback;
        if (typeof val === "string") {
            // Check for 8-digit hex (RRGGBBAA)
            if (val.match(/^#[0-9a-fA-F]{8}$/)) {
                let r = parseInt(val.substring(1, 3), 16) / 255;
                let g = parseInt(val.substring(3, 5), 16) / 255;
                let b = parseInt(val.substring(5, 7), 16) / 255;
                let a = parseInt(val.substring(7, 9), 16) / 255;
                return Qt.rgba(r, g, b, a);
            }
            const rgbaMatch = val.match(/rgba\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)/);
            if (rgbaMatch)
                return Qt.rgba(parseInt(rgbaMatch[1]) / 255, parseInt(rgbaMatch[2]) / 255, parseInt(rgbaMatch[3]) / 255, parseFloat(rgbaMatch[4]));

        }
        return val;
    }

}
