// AccountPage.qml - User account creation
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami

Item {
    id: accountPage
    property string fullName: ""
    property string username: ""
    property string password: ""
    property int passwordStrength: 0
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 40
        spacing: 24
        
        Label {
            text: "Create Your Account"
            font.pixelSize: 28
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignHCenter
        }
        
        Label {
            text: "Set up your user account"
            opacity: 0.7
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Avatar selection
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 24
            
            Rectangle {
                width: 100; height: 100
                radius: 50
                color: Kirigami.Theme.highlightColor
                
                Label {
                    anchors.centerIn: parent
                    text: fullName.length > 0 ? fullName.charAt(0).toUpperCase() : "?"
                    font.pixelSize: 40
                    font.weight: Font.Bold
                    color: Kirigami.Theme.highlightedTextColor
                }
            }
            
            ColumnLayout {
                spacing: 8
                Button { text: "Take Photo"; icon.name: "camera-photo" }
                Button { text: "Choose Image"; icon.name: "folder-pictures"; flat: true }
            }
        }
        
        // Form fields
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 16
            columnSpacing: 16
            
            Label { text: "Full Name" }
            TextField {
                id: nameField
                Layout.fillWidth: true
                placeholderText: "John Doe"
                onTextChanged: {
                    fullName = text
                    if (usernameField.text === "") {
                        username = text.toLowerCase().replace(/ /g, "").substring(0, 16)
                    }
                }
            }
            
            Label { text: "Username" }
            TextField {
                id: usernameField
                Layout.fillWidth: true
                placeholderText: "johndoe"
                validator: RegExpValidator { regExp: /^[a-z_][a-z0-9_-]{0,31}$/ }
                text: username
                onTextChanged: username = text
            }
            
            Label { text: "Password" }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                
                TextField {
                    id: pwField
                    Layout.fillWidth: true
                    echoMode: showPw.checked ? TextInput.Normal : TextInput.Password
                    placeholderText: "Password"
                    onTextChanged: {
                        password = text
                        passwordStrength = calculateStrength(text)
                    }
                }
                
                // Strength meter
                RowLayout {
                    spacing: 4
                    Repeater {
                        model: 4
                        Rectangle {
                            width: 50; height: 4; radius: 2
                            color: index < passwordStrength ? 
                                (passwordStrength >= 3 ? Kirigami.Theme.positiveTextColor :
                                 passwordStrength >= 2 ? Kirigami.Theme.neutralTextColor :
                                 Kirigami.Theme.negativeTextColor) : 
                                Kirigami.Theme.disabledTextColor
                        }
                    }
                    Label {
                        text: ["Weak", "Fair", "Good", "Strong"][Math.max(0, passwordStrength - 1)] || ""
                        font.pixelSize: 11
                        opacity: 0.7
                    }
                }
            }
            
            Label { text: "Confirm" }
            TextField {
                id: confirmField
                Layout.fillWidth: true
                echoMode: showPw.checked ? TextInput.Normal : TextInput.Password
                placeholderText: "Confirm password"
            }
        }
        
        CheckBox {
            id: showPw
            text: "Show passwords"
        }
        
        // Password mismatch warning
        Label {
            text: "\u26a0 Passwords don't match"
            color: Kirigami.Theme.negativeTextColor
            visible: confirmField.text.length > 0 && confirmField.text !== pwField.text
        }
        
        Item { Layout.fillHeight: true }
        
        CheckBox {
            text: "Log in automatically"
            checked: false
        }
        
        Label {
            text: "\ud83d\udee1 This account will have administrator privileges"
            font.pixelSize: 12
            opacity: 0.7
        }
    }
    
    function calculateStrength(pw) {
        if (pw.length < 4) return 0
        var score = 0
        if (pw.length >= 8) score++
        if (/[A-Z]/.test(pw)) score++
        if (/[0-9]/.test(pw)) score++
        if (/[^A-Za-z0-9]/.test(pw)) score++
        return score
    }
}
