// LanguagePage.qml - Language selection
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: languagePage
    
    property string selectedLocale: "en_US"
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Select Your Language"
            font.pixelSize: 28
            font.weight: Font.DemiBold
        }
        
        Label {
            text: "Choose the language for your system."
            opacity: 0.7
        }
        
        // Search field
        TextField {
            id: searchField
            Layout.fillWidth: true
            placeholderText: "Search languages..."
            
            Kirigami.Icon {
                anchors.left: parent.left
                anchors.leftMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                source: "search"
                width: 16
                height: 16
            }
        }
        
        // Language list
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ListView {
                id: languageList
                model: languageModel
                clip: true
                
                delegate: ItemDelegate {
                    width: ListView.view.width
                    height: 56
                    highlighted: locale === selectedLocale
                    
                    onClicked: selectedLocale = locale
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 16
                        
                        Label {
                            text: flag
                            font.pixelSize: 24
                        }
                        
                        ColumnLayout {
                            spacing: 2
                            Label {
                                text: name
                                font.weight: Font.Medium
                            }
                            Label {
                                text: nativeName
                                font.pixelSize: 12
                                opacity: 0.7
                            }
                        }
                        
                        Item { Layout.fillWidth: true }
                        
                        Kirigami.Icon {
                            source: "checkbox-checked"
                            visible: locale === selectedLocale
                            width: 20
                            height: 20
                        }
                    }
                }
            }
        }
    }
    
    ListModel {
        id: languageModel
        ListElement { name: "English (US)"; nativeName: "English"; locale: "en_US"; flag: "🇺🇸" }
        ListElement { name: "English (UK)"; nativeName: "English"; locale: "en_GB"; flag: "🇬🇧" }
        ListElement { name: "Indonesian"; nativeName: "Bahasa Indonesia"; locale: "id_ID"; flag: "🇮🇩" }
        ListElement { name: "German"; nativeName: "Deutsch"; locale: "de_DE"; flag: "🇩🇪" }
        ListElement { name: "French"; nativeName: "Français"; locale: "fr_FR"; flag: "🇫🇷" }
        ListElement { name: "Spanish"; nativeName: "Español"; locale: "es_ES"; flag: "🇪🇸" }
        ListElement { name: "Japanese"; nativeName: "日本語"; locale: "ja_JP"; flag: "🇯🇵" }
        ListElement { name: "Korean"; nativeName: "한국어"; locale: "ko_KR"; flag: "🇰🇷" }
        ListElement { name: "Chinese (Simplified)"; nativeName: "简体中文"; locale: "zh_CN"; flag: "🇨🇳" }
        ListElement { name: "Hindi"; nativeName: "हिन्दी"; locale: "hi_IN"; flag: "🇮🇳" }
    }
}
