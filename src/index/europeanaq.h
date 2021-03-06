#ifndef EAUROPEANAQ_H
#define EAUROPEANAQ_H

#include <map>
#include <vector>
#include "airqualityindex.h"

class EuropeanAQ : public AirQualityIndex
{
public:
    EuropeanAQ();

    virtual void calculate(StationPtr station, std::function<void(StationIndexPtr)> handler) override;
    virtual QString name() override;

private:
    StationIndexPtr recalculate(SensorListPtr sensorList);

    std::map<QString, Pollution> m_parametersThreshold;
    std::vector<QString> m_names;
};

#endif // EAUROPEANAQ_H
