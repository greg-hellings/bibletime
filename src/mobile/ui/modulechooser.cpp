/*********
*
* In the name of the Father, and of the Son, and of the Holy Spirit.
*
* This file is part of BibleTime's source code, http://www.bibletime.info/.
*
* Copyright 1999-2016 by the BibleTime developers.
* The BibleTime source code is licensed under the GNU General Public License
* version 2.0.
*
**********/

#include "modulechooser.h"

#include <cmath>
#include <QQuickItem>
#include <QQmlProperty>
#include "backend/bookshelfmodel/btbookshelftreemodel.h"
#include "backend/managers/cswordbackend.h"
#include "btwindowinterface.h"
#include "mobile/util/findqmlobject.h"
#include "qtquick2applicationviewer.h"
#include "util/btassert.h"
#include "util/btconnect.h"


namespace btm {

ModuleChooser::ModuleChooser(QtQuick2ApplicationViewer* viewer, BtWindowInterface* windowInterface)
    : viewer_(viewer),
      windowInterface_(windowInterface) {
}

void ModuleChooser::open() {
    QQuickItem* item = findQmlObject("moduleChooser");
    BT_ASSERT(item);
    if (item == nullptr)
        return;

    item->setProperty("visible", true);
    disconnect(item, SIGNAL(moduleSelected()), nullptr, nullptr);
    BT_CONNECT(item, SIGNAL(moduleSelected()),
               this, SLOT(moduleSelectedSlot()));
}

void ModuleChooser::moduleSelectedSlot() {
    QQuickItem* item = findQmlObject("moduleChooser");
    BT_ASSERT(item);
    if (item == nullptr)
        return;

    item->setProperty("visible", false);
    QVariant v = item->property("selectedModule");
    QString moduleName = v.toString();
    windowInterface_->moduleNameChanged(moduleName);
}

} // end namespace
