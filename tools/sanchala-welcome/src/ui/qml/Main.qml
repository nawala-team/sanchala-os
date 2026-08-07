// Main.qml - Sanchala Welcome Wizard
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import org.kde.kirigami 2.19 as Kirigami

ApplicationWindow {
    id: root
    title: "Welcome to Sanchala OS"
    width: 900
    height: 650
    visible: true
    color: Kirigami.Theme.backgroundColor
    
    flags: Qt.Window | Qt.FramelessWindowHint
    
    property int currentPage: 0
    property int totalPages: 12
    
    // Page model
    ListModel {
        id: pagesModel
        ListElement { name: "welcome"; title: "Welcome" }
        ListElement { name: "language"; title: "Language" }
        ListElement { name: "region"; title: "Region" }
        ListElement { name: "keyboard"; title: "Keyboard" }
        ListElement { name: "network"; title: "Network" }
        ListElement { name: "account"; title: "Account" }
        ListElement { name: "security"; title: "Security" }
        ListElement { name: "privacy"; title: "Privacy" }
        ListElement { name: "appearance"; title: "Appearance" }
        ListElement { name: "online"; title: "Online Accounts" }
        ListElement { name: "done"; title: "All Done" }
        ListElement { name: "tour"; title: "Tour" }
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Custom title bar
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: Kirigami.Theme.headerBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Kirigami.Icon {
                    source: "sanchala-logo"
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                }
                
                Label {
                    text: "Sanchala OS Setup"
                    font.bold: true
                }
                
                Item { Layout.fillWidth: true }
                
                // Progress indicator
                Label {
                    text: (currentPage + 1) + " / " + totalPages
                    opacity: 0.7
                }
            }
            
            MouseArea {
                anchors.fill: parent
                property point clickPos
                onPressed: clickPos = Qt.point(mouse.x, mouse.y)
                onPositionChanged: {
                    root.x += mouse.x - clickPos.x
                    root.y += mouse.y - clickPos.y
                }
            }
        }
        
        // Progress bar
        ProgressBar {
            Layout.fillWidth: true
            value: (currentPage + 1) / totalPages
            
            background: Rectangle {
                implicitHeight: 4
                color: Kirigami.Theme.backgroundColor
            }
            
            contentItem: Rectangle {
                width: parent.visualPosition * parent.width
                height: parent.height
                color: Kirigami.Theme.highlightColor
            }
        }
        
        // Page content
        StackLayout {
            id: pageStack
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: currentPage
            
            Loader { source: "pages/WelcomePage.qml" }
            Loader { source: "pages/LanguagePage.qml" }
            Loader { source: "pages/RegionPage.qml" }
            Loader { source: "pages/KeyboardPage.qml" }
            Loader { source: "pages/NetworkPage.qml" }
            Loader { source: "pages/AccountPage.qml" }
            Loader { source: "pages/SecurityPage.qml" }
            Loader { source: "pages/PrivacyPage.qml" }
            Loader { source: "pages/AppearancePage.qml" }
            Loader { source: "pages/OnlineAccountsPage.qml" }
            Loader { source: "pages/AllDonePage.qml" }
            Loader { source: "pages/TourOfferPage.qml" }
        }
        
        // Navigation buttons
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: Kirigami.Theme.headerBackgroundColor
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                
                Button {
                    text: "Back"
                    visible: currentPage > 0
                    onClicked: currentPage--
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: pagesModel.get(currentPage).name === "network" || 
                          pagesModel.get(currentPage).name === "online" ? "Skip" : ""
                    visible: text !== ""
                    flat: true
                    onClicked: currentPage++
                }
                
                Button {
                    text: currentPage === totalPages - 1 ? "Get Started" : "Continue"
                    highlighted: true
                    onClicked: {
                        if (currentPage < totalPages - 1) {
                            currentPage++
                        } else {
                            // Complete setup
                            Qt.quit()
                        }
                    }
                }
            }
        }
    }
}
