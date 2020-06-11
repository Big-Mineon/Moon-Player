import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.3 as SystemDialog
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0 as QSettings
import MoonPlayer 1.0
import CustomWidgets 1.0

CustomTabDialog {
    
    id: window
    width: 600
    height: 400
    title: qsTr("Settings")

    model: ListModel {
        ListElement { tabLabel: qsTr("Player") }
        ListElement { tabLabel: qsTr("Video") }
        ListElement { tabLabel: qsTr("Audio") }
        ListElement { tabLabel: qsTr("Danmaku") }
        ListElement { tabLabel: qsTr("Network") }
        ListElement { tabLabel: qsTr("Downloader") }
        ListElement { tabLabel: qsTr("Shortcuts") }
    }

    content: StackLayout {
        currentIndex: window.currentIndex
        
        // Player settings
        QSettings.Settings {
            id: playerSettings
            category: "player"
            property alias style: styleComboBox.currentIndex
            property alias use_system_frame: systemFrameCheckBox.checked
            property alias url_open_mode: openUrlComboBox.currentIndex
        }
     
        // Video settings
        QSettings.Settings {
            id: videoSettings
            category: "video"
            property alias hwdec: hwdecComboBox.currentIndex
            property alias hwdec_copy_mode: copyModeCheckBox.checked
        }
    
        // Audio settings
        QSettings.Settings {
            id: audioSettings
            category: "audio"
            property alias output: audioOutputComboBox.currentIndex
        }
    
        // Danmaku settings
        QSettings.Settings {
            id: danmakuSettings
            category: "danmaku"
            property alias alpha: alphaSpinBox.value
            property alias dm: dmSpinBox.value
            property alias ds: dsSpinBox.value
            property alias font: fontDialog.font
            property alias font_size: fontSizeSpinBox.value
        }
    
        // Network settings
        QSettings.Settings {
            id: networkSettings
            category: "network"
            property alias proxy_type: proxyModeComboBox.currentIndex
            property alias proxy: proxyInput.text
            property alias proxy_only_for_parsing: proxyParsingOnlyCheckBox.checked
            onProxyChanged: accessManager.setupProxy(proxy_type, proxy, proxy_only_for_parsing)
            onProxy_typeChanged: accessManager.setupProxy(proxy_type, proxy, proxy_only_for_parsing)
            onProxy_only_for_parsingChanged: accessManager.setupProxy(proxy_type, proxy, proxy_only_for_parsing)
        }
    
        // Downloader settings
        QSettings.Settings {
            id: downloaderSettings
            category: "downloader"
            property alias save_to: fileDialog.folder
            property alias max_threads: maxThreadsSpinBox.value
        }
        
        // Player
        GridLayout {
            columns: 2
            columnSpacing: 40
            
            Label { text: qsTr("Style:") }
            ComboBox {
                id: styleComboBox
                model: [ "Mix", "Dark", "Light" ]
                onCurrentTextChanged: Color.theme = currentText
            }
            
            CheckBox {
                id: systemFrameCheckBox
                text: qsTr("Use system window frame")
                Layout.columnSpan: 2
            }
            
            Label { text: qsTr("When opening an URL:") }
            ComboBox {
                id: openUrlComboBox
                model: [ qsTr("Question"), qsTr("Play"), qsTr("Download") ]
            }
        }
        
        // Video
        GridLayout {
            columns: 2
            columnSpacing: 40
            Label { text: qsTr("Hardware decoding:") }
            ComboBox {
                id: hwdecComboBox
                model: [ "auto", "vaapi", "vdpau" ]
            }
            StackLayout {
                Layout.columnSpan: 2
                Layout.fillHeight: false
                currentIndex: hwdecComboBox.currentIndex
                Label { text: qsTr("Choose hardware decoder automatically.") }
                Label { text: qsTr("Intel hardware decoding on Linux.") }
                Label { text: qsTr("Nvidia hardware decoding on Linux.") }
            }
            
            MenuSeparator { Layout.columnSpan: 2; Layout.fillWidth: true }
            CheckBox { id: copyModeCheckBox; text: qsTr("Copy mode"); Layout.columnSpan: 2 }
            Label {
                text: qsTr("This option will make all video filters work under hardware decoding, but it will comsume more hardware resources.")
                wrapMode: Text.WordWrap
                Layout.maximumWidth: 400
                Layout.columnSpan: 2
            }
            
            MenuSeparator { Layout.columnSpan: 2; Layout.fillWidth: true }
            Label {
                text: qsTr("The settings above will be applied after restart.")
                wrapMode: Text.WordWrap
                Layout.maximumWidth: 400
                Layout.columnSpan: 2
            }
        }
            
        // Audio
        GridLayout {
            columns: 2
            columnSpacing: 40
            Label { text: qsTr("Audio output:") }
            ComboBox {
                id: audioOutputComboBox
                model: [ "auto" ]
            }
            
            MenuSeparator { Layout.columnSpan: 2; Layout.fillWidth: true }
            Label {
                text: qsTr("The settings above will be applied after restart.")
                wrapMode: Text.WordWrap
                Layout.maximumWidth: 400
                Layout.columnSpan: 2
            }
        }
        
        // Danmaku
        GridLayout {
            columns: 2
            columnSpacing: 20
            
            Label { text: qsTr("Font:") }
            Button {
                text: fontDialog.font.family
                onClicked: fontDialog.open()
            }
            SystemDialog.FontDialog {
                id: fontDialog
                title: qsTr("Please choose a font for Danmaku")
            }
                
            Label { text: qsTr("Font size:") + " (*)" }
            SpinBox { id: fontSizeSpinBox; from: 0; to: 100; value: 0; implicitWidth: 140 }
            
            Label { text: qsTr("Alpha (%):") }
            SpinBox { id: alphaSpinBox; from: 0; to: 100; value: 100; implicitWidth: 140 }
            
            Label { text: qsTr("Duration of scrolling comment display:") + " (*)" }
            SpinBox { id: dmSpinBox; from: 0; to: 100; value: 0; implicitWidth: 140 }
            
            Label { text: qsTr("Duration of still comment display:") }
            SpinBox { id: dsSpinBox; from: 0; to: 100; value: 6; implicitWidth: 140 }
            
            MenuSeparator { Layout.columnSpan: 2; Layout.fillWidth: true }
            Label { text: "(*): " + qsTr("Set to 0 to let MoonPlayer choose automatically."); Layout.columnSpan: 2 }
        }
        
        // Network
        GridLayout {
            columns: 2
            columnSpacing: 20
            Label { text: qsTr("Proxy mode:") }
            ComboBox {
                id: proxyModeComboBox
                model: [ "no", "http", "socks5" ]
            }
            
            Label { text: qsTr("Proxy:") }
            TextField {
                id: proxyInput
                width: 300
                color: !text.match(/^.+:\d+$/) ? "red" : playerSettings.style == 1 ? "white" : "black"
                validator: RegExpValidator { regExp: /.+:\d+/ }
            }
            
            Label {
                text: qsTr("Note: Due to the limitation of mpv, socks5 proxy is not supported by online playing.")
                wrapMode: Text.WordWrap
                Layout.maximumWidth: 400
                Layout.columnSpan: 2
            }
            
            CheckBox {
                id: proxyParsingOnlyCheckBox
                text: qsTr("Use proxy only for parsing videos")
                Layout.columnSpan: 2
            }
        }
        
        // Downloader
        GridLayout {
            columns: 2
            columnSpacing: 40
            
            Label { text: qsTr("Maximun number of threads:") }
            SpinBox { id: maxThreadsSpinBox; from: 0; to: 100; value: 5 }
            
            Label { text: qsTr("Save to:") }
            Button {
                text: fileDialog.folder.toString().replace("file://", "")
                onClicked: fileDialog.open()
                // Flatpak version is sandboxed and has no permission to access other folders
                enabled: utils.environmentVariable("FLATPAK_SANDBOX_DIR") == ""
            }
            SystemDialog.FileDialog {
                id: fileDialog
                title: "Please choose a folder"
                folder: shortcuts.movies
                selectFolder: true
            }
        }
        
        // Shortcuts
        GridLayout {
            columns: 2
            rowSpacing: 0
            columnSpacing: 40
            Label { text: "Left/Right" }
            Label { text: qsTr("Navigation") }
            Label { text: "Up/Down" }
            Label { text: qsTr("Set volume") }
            Label { text: "Space" }
            Label { text: qsTr("Pause/continue") }
            Label { text: "Return" }
            Label { text: qsTr("Enter/exit fullscreen") }
            Label { text: "Esc" }
            Label { text: qsTr("Exit fullscreen") }
            Label { text: "S" }
            Label { text: qsTr("Screenshot") }
            Label { text: "D" }
            Label { text: qsTr("Switch on/off danmaku") }
            Label { text: "L" }
            Label { text: qsTr("Show playlist") }
            Label { text: "U" }
            Label { text: qsTr("Open URL") }
            Label { text: "W" }
            Label { text: qsTr("Open Explorer") }
            Label { text: "R" }
            Label { text: qsTr("Set speed to default") }
            Label { text: "Ctrl+Left" }
            Label { text: qsTr("Speed down") }
            Label { text: "Ctrl+Right" }
            Label { text: qsTr("Speed up") }
            Label { text: "Ctrl+O" }
            Label { text: qsTr("Open files") }
            Label { text: "Ctrl+," }
            Label { text: qsTr("Open settings") }
        }
    }
}
