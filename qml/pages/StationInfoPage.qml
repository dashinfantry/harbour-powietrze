import QtQuick 2.2
import Sailfish.Silica 1.0

import StationListModel 1.0
import SensorListModel 1.0
import ProviderListModel 1.0
import Settings 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    onStatusChanged: {
            if (status === PageStatus.Deactivating) {
                changeCoverPage(Qt.resolvedUrl("../cover/CoverPage.qml"));
            }
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                id: addFevourite
                text: qsTr("Add to favourite")
                onClicked: {
                    stationListModel.selectedStation.favourite = true
                    Settings.addFavouriteStation(stationListModel.selectedStation)
                }
            }

            MenuItem {
                id: removeFevourite
                text: qsTr("Remove from favourite")
                onClicked: {
                    stationListModel.selectedStation.favourite = false
                    Settings.removeFavouriteStation(stationListModel.selectedStation.id)
                }
            }
        }

        PageHeader {
            id: pageHeader
        }

        BusyIndicator {
            id: loading
            anchors.centerIn: parent
            running: true
            size: BusyIndicatorSize.Large
            anchors.verticalCenter: parent.verticalCenter
            visible: false
        }

        Item {
            id: station
            enabled: true
            visible: true
            width: parent.width
            height: parent.height
            anchors.top: pageHeader.bottom

            Item {
                id: index
                width: parent.width
                height: image.height + label.height

                Image {
                    id: image
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: label
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.topMargin: Theme.paddingSmall
                    anchors.top: image.bottom
                }
            }

            SectionHeader {
                id: dataSection
                anchors.top: index.bottom
                textFormat: Text.RichText
                text: qsTr("data (" + Settings.unitName() + ")")
            }

            SilicaListView {
                id: listView
                model: sensorListModel

                width: parent.width
                height: parent.height
                anchors.top: dataSection.bottom

                delegate: Row {
                    id: delegate

                    spacing: Theme.paddingMedium
                    anchors.horizontalCenter: parent.horizontalLeft

                    Label {
                        width: page.width / 2
                        text: model.name
                        color: Theme.secondaryHighlightColor
                        horizontalAlignment: Text.AlignRight
                    }
                    Label {
                        horizontalAlignment: Text.AlignLeft
                        text: model.value
                        fontSizeMode: Theme.fontSizeSmall
                        color: Theme.highlightColor
                    }
                    VerticalScrollDecorator {}
                }
            }
        }

        Label {
            id: prviderLabel
            width: parent.width
            anchors.bottom: parent.bottom
            font.pixelSize: Theme.fontSizeExtraSmall
            color: Theme.secondaryColor
            anchors.bottomMargin: Theme.paddingSmall
            horizontalAlignment: Text.AlignHCenter
        }

        Connections {
            target: stationListModel
            onStationDataRequested: {
                loading.enabled = true
                loading.visible = true
                station.enabled = false
                station.visible = false
            }
        }

        Connections {
            target: stationListModel
            onStationDataLoaded: {
                loading.enabled = false
                loading.visible = false
                station.enabled = true
                station.visible = true

                pageHeader.title = stationListModel.selectedStation.name
                label.text = stationListModel.selectedStation.stationIndex.name
                image.source = "qrc:///Graphics/weatherIcons/256/" + stationListModel.selectedStation.stationIndex.id + ".png"

                addFevourite.visible = !stationListModel.selectedStation.favourite
                removeFevourite.visible = stationListModel.selectedStation.favourite

                changeCoverPage(Qt.resolvedUrl("../cover/StationCoverPage.qml"));

                prviderLabel.text = qsTr("Data by ") + providerListModel.site(stationListModel.selectedStation.provider)
            }
        }

        Connections {
            target: stationListModel
            onDataChanged: {
                pageHeader.title = stationListModel.selectedStation.name
                label.text = stationListModel.selectedStation.stationIndex.name
                image.source = "qrc:///Graphics/weatherIcons/256/" + stationListModel.selectedStation.stationIndex.id + ".png"

                addFevourite.visible = !stationListModel.selectedStation.favourite
                removeFevourite.visible = stationListModel.selectedStation.favourite
            }
        }
    }
}
