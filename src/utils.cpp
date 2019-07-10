#include "utils.h"
#include <notification.h>

void Utils::SimpleNotification(QString header, QString body)
{
    Notification notification;
    notification.setBody(body);
    notification.setPreviewSummary(header);
    notification.setPreviewBody(body);
    notification.publish();
}
