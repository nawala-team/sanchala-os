// ============================================
// SANCHALA OS - Accessibility Settings Panel
// ============================================
// QML UI for KCM Accessibility Module
// /usr/share/kpackage/kcms/kcm_sanchala_accessibility/contents/ui/main.qml
// ============================================

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.kcm 1.3 as KCM

KCM.ScrollViewKCM {
    id: root
    
    title: i18n("Accessibility")
    
    header: ColumnLayout {
        Kirigami.InlineMessage {
            id: profileMessage
            Layout.fillWidth: true
            type: Kirigami.MessageType.Information
            text: i18n("Quick setup: Choose a profile that matches your needs")
            visible: true
            
            actions: [
                Kirigami.Action {
                    text: i18n("Low Vision")
                    onTriggered: kcm.applyProfile("low-vision")
                },
                Kirigami.Action {
                    text: i18n("Screen Reader")
                    onTriggered: kcm.applyProfile("blind")
                },
                Kirigami.Action {
                    text: i18n("Motor")
                    onTriggered: kcm.applyProfile("motor")
                }
            ]
        }
    }
    
    view: ListView {
        model: ListModel {
            ListElement { section: "vision"; title: qsTr("Vision") }
            ListElement { section: "hearing"; title: qsTr("Hearing") }
            ListElement { section: "mobility"; title: qsTr("Mobility") }
            ListElement { section: "reading"; title: qsTr("Reading") }
        }
        
        delegate: Kirigami.AbstractCard {
            width: ListView.view.width
            
            header: Kirigami.Heading {
                text: model.title
                level: 2
            }
            
            contentItem: Loader {
                source: model.section + "Section.qml"
            }
        }
    }
}
