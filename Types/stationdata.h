#ifndef STATIONDATA_H
#define STATIONDATA_H

#include <QtCore>
#include <QString>
#include <QDataStream>
#include <QtPositioning/QGeoCoordinate>

struct StationData
{
    int id;
    QString province;
    QString country;
    QString cityName;
    QString street;
    QGeoCoordinate coordinate;
    int provider;
};

QDataStream& operator<<(QDataStream& out, const StationData& v);
QDataStream& operator>>(QDataStream& in, StationData& v);

Q_DECLARE_METATYPE(StationData)

#endif // STATIONDATA_H
