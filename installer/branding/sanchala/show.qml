import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Presentation {
    id: presentation

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Image {
                    source: "logo.png"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 150
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "Welcome to Sanchala OS"
                    color: "white"
                    font.pixelSize: 32
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Set Your System in Motion"
                    color: "#B0BEC5"
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "🎨 Beautiful Design"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "macOS-inspired interface with KDE Plasma 6\n" +
                          "Floating dock, global menu, blur effects\n" +
                          "Smooth 60fps animations"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "🔒 Security Beyond Apple"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "8-layer security architecture\n" +
                          "Hardened kernel, AppArmor, sandboxing\n" +
                          "Full disk encryption with TPM support"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "📦 100% Linux Compatible"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Flatpak, Pacman, AUR, AppImage\n" +
                          "All your favorite apps work\n" +
                          "No custom format required"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "🦁 Brave Browser"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Privacy-focused default browser\n" +
                          "Built-in ad and tracker blocker\n" +
                          "Faster and more secure browsing"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "🔄 Reliable & Recoverable"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Automatic Btrfs snapshots\n" +
                          "Easy rollback from GRUB\n" +
                          "Your system, always recoverable"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Slide {
        Rectangle {
            anchors.fill: parent
            color: "#1A237E"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "✨ Part of NAWALA Ecosystem"
                    color: "white"
                    font.pixelSize: 28
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "SANCHALA • NAWALA • RAKSHA\n\n" +
                          "Sanskrit-inspired tools\n" +
                          "for modern infrastructure"
                    color: "#B0BEC5"
                    font.pixelSize: 16
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    function goToNextSlide() {
        if (currentSlide < slides.length - 1) {
            currentSlide++
        } else {
            currentSlide = 0
        }
    }
}
