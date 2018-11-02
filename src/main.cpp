/*
 * Copyright (C) 2014  Vishesh Handa <vhanda@kde.org>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>

#include <QStandardPaths>
#include <QDebug>

#include <KLocalizedString>

#include <QApplication>

#include <iostream>

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    app.setApplicationDisplayName("LLs vPlayer");

    QStringList locations = QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);
    Q_ASSERT(locations.size() >= 1);
    qDebug() << "Standard Media Locations:" << locations;

    QString videoFolder = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
    QString homeFolder = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);

    QQmlEngine engine;
    QQmlContext* objectContext = engine.rootContext();
    objectContext->setContextProperty("homePath", homeFolder);
    objectContext->setContextProperty("videoPath", videoFolder);

    QString path = QStandardPaths::locate(QStandardPaths::DataLocation, "main.qml");
    qDebug() << "Data path:" << path;

    QQmlComponent component(&engine, path);
    if (component.isError()) {
        qDebug() << component.errorString().toUtf8().constData();
        Q_ASSERT(0);
    }
    Q_ASSERT(component.status() == QQmlComponent::Ready);
    component.create(objectContext);

    int rt = app.exec();
    return rt;
}
