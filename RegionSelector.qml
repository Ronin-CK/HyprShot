import QtQuick

Item {
    id: root

    signal regionSelected(real x, real y, real width, real height)

    // Shader properties
    property real dimOpacity: 0.6
    property real borderRadius: 10.0
    property real outlineThickness: 2.0
    property url fragmentShader: Qt.resolvedUrl("dimming.frag.qsb")

    property point startPos
    property bool isDragging: mouseArea.pressed

    // Selection Box Geometry
    property real selectionX: 0
    property real selectionY: 0
    property real selectionWidth: 0
    property real selectionHeight: 0

    // Mouse Tracking
    property real mouseX: 0
    property real mouseY: 0

    // Animations: Only enabled when NOT dragging to avoid stutter
    Behavior on selectionX { enabled: !root.isDragging; SpringAnimation { spring: 4; damping: 0.4 } }
    Behavior on selectionY { enabled: !root.isDragging; SpringAnimation { spring: 4; damping: 0.4 } }
    Behavior on selectionHeight { enabled: !root.isDragging; SpringAnimation { spring: 4; damping: 0.4 } }
    Behavior on selectionWidth { enabled: !root.isDragging; SpringAnimation { spring: 4; damping: 0.4 } }

    // 1. Dimming Background (GPU Shader)
    ShaderEffect {
        anchors.fill: parent
        z: 0
        property vector4d selectionRect: Qt.vector4d(root.selectionX, root.selectionY, root.selectionWidth, root.selectionHeight)
        property real dimOpacity: root.dimOpacity
        property vector2d screenSize: Qt.vector2d(root.width, root.height)
        property real borderRadius: root.borderRadius
        property real outlineThickness: root.outlineThickness
        fragmentShader: root.fragmentShader
    }

    // 2. Optimized GPU Guides (Using Rectangles instead of Canvas)
    // Vertical Guide
    Rectangle {
        x: root.isDragging ? root.selectionX : root.mouseX
        y: 0; width: 1; height: parent.height
        color: "white"; opacity: 0.3; z: 2
    }
    Rectangle {
        x: root.isDragging ? (root.selectionX + root.selectionWidth) : -1
        y: 0; width: 1; height: parent.height
        color: "white"; opacity: 0.3; z: 2; visible: root.isDragging
    }

    // Horizontal Guide
    Rectangle {
        x: 0; y: root.isDragging ? root.selectionY : root.mouseY
        width: parent.width; height: 1
        color: "white"; opacity: 0.3; z: 2
    }
    Rectangle {
        x: 0; y: root.isDragging ? (root.selectionY + root.selectionHeight) : -1
        width: parent.width; height: 1
        color: "white"; opacity: 0.3; z: 2; visible: root.isDragging
    }

    // 3. Mouse Interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z: 3
        hoverEnabled: true
        cursorShape: Qt.CrossCursor

        onPressed: (mouse) => {
            root.startPos = Qt.point(mouse.x, mouse.y)
            root.selectionX = mouse.x
            root.selectionY = mouse.y
            root.selectionWidth = 0
            root.selectionHeight = 0
        }

        onPositionChanged: (mouse) => {
            root.mouseX = mouse.x
            root.mouseY = mouse.y

            if (pressed) {
                root.selectionX = Math.min(root.startPos.x, mouse.x)
                root.selectionY = Math.min(root.startPos.y, mouse.y)
                root.selectionWidth = Math.abs(mouse.x - root.startPos.x)
                root.selectionHeight = Math.abs(mouse.y - root.startPos.y)
            }
        }

        onReleased: {
            root.regionSelected(
                Math.round(root.selectionX),
                Math.round(root.selectionY),
                Math.round(root.selectionWidth),
                Math.round(root.selectionHeight)
            )
        }
    }
}
