import QtQuick 2.1
import QtWebKit 3.0
import BibleTime 1.0

Rectangle {
    id: htmlView

    property string title: toolbar.title

    function setModule(module) {
        btWindowInterface.moduleName = module;
    }

    color: "black"

    BtWindowInterface {
        id: btWindowInterface

        onTextChanged: {
            webView.loadHtml(btWindowInterface.text)
        }
    }

    BtStyle {
        id:btStyle
    }

    Rectangle {
        id: toolbar

        property string title: btWindowInterface.moduleName + " (" + btWindowInterface.displayed + ")"

        width: parent.width
        height: 36
        color: btStyle.toolbarColor
        border.width: 1
        border.color: "black"

        Rectangle {
            id: moduleDisplay

            width: text.width +10
            radius:btStyle.buttonRadius
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 4
            anchors.leftMargin: 5
            anchors.bottomMargin: 4
            color: btStyle.toolbarButton
            border.color: btStyle.buttonBorder
            border.width: 1

            Text {
                id: text

                anchors.centerIn: parent
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                font.pointSize: btStyle.uiTextPointSize
                elide: Text.ElideMiddle
                color: btStyle.toolbarButtonText
                text: btWindowInterface.moduleName
            }

            MouseArea {
                id: moduleMouseArea

                anchors.fill: parent
                onClicked: {
                    btWindowInterface.changeModule();
                }
            }
        }

        Rectangle {
            id: referenceDisplay

            width: {
                var w1 = 300
                var w2 = toolbar.width - moduleDisplay.width;
                var w = Math.min(w1,w2);
                return w - 15;
            }
            radius: btStyle.buttonRadius
            anchors.left: moduleDisplay.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin: 4
            anchors.bottomMargin: 4
            anchors.leftMargin: 5
            color: btStyle.toolbarButton
            border.color: btStyle.buttonBorder
            border.width: 1

            Text {
                id: referenceText
                anchors.centerIn: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 4
                width: referenceDisplay.width - 4
                font.pointSize: btStyle.uiTextPointSize
                elide: Text.ElideMiddle
                color: btStyle.toolbarButtonText
                text: btWindowInterface.displayed
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent
                onClicked: {
                    btWindowInterface.changeReference();
                }
            }
        }
    }

    WebView {
        id: webView

        anchors.top: toolbar.bottom
        anchors.bottom: htmlView.bottom
        anchors.left: htmlView.left
        anchors.right: htmlView.right

        function contextMenus() {
            contextMenu.visible = true;
        }

        MouseArea {
            id: mouseWebView

            anchors.fill: parent

            onDoubleClicked: {
                webView.contextMenus();
            }

            onPressAndHold: {
                webView.contextMenus();
            }
        }
    }

    ListModel {
        id: contextMenuModel

        ListElement { title: "Text Font Size"; action: "textSize" }
    }

    ContextMenu {
        id: contextMenu

        function doAction(action) {
            fontPointSize.visible = true;
        }

        model: contextMenuModel
        visible: false
        Component.onCompleted: contextMenu.accepted.connect(contextMenu.doAction)
    }

    FontSizeSlider {
        id: fontPointSize
        visible: false
        title: "Text Font Point Size"

        onVisibleChanged: {
            if (visible)
                fontPointSize.current = btWindowInterface.fontSize
        }

        onAccepted: {
            console.log("text: ",fontPointSize.current);
            btWindowInterface.fontSize = fontPointSize.current;
        }
    }


}