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

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QQmlContext>
#include <QStandardPaths>
#include <QtQml>


int main(int argc, char** argv)
{
	QGuiApplication app(argc, argv);
	
	// attributes
	QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	
	QQmlApplicationEngine engine;

	QGuiApplication::setApplicationName("vplayer");
	QGuiApplication::setApplicationDisplayName("LLs Video Player");

	// QStandardPaths
	QStringList locations = QStandardPaths::standardLocations(QStandardPaths::MoviesLocation);
	Q_ASSERT(locations.size() >= 1);
	qDebug() << locations;

	QString videoFolder = QStandardPaths::writableLocation(QStandardPaths::MoviesLocation);
	QString homeFolder = QStandardPaths::writableLocation(QStandardPaths::HomeLocation);

	QQmlContext* objectContext = engine.rootContext();
	objectContext->setContextProperty("homePath", homeFolder);
	objectContext->setContextProperty("videoPath", videoFolder);

	// QtQuickControls2 Style
	qputenv("QT_QUICK_CONTROLS_STYLE", "plasma");
	
	
	engine.load(QUrl("qrc:/src/qml/main.qml"));
	
	QObject *topLevel = engine.rootObjects().value(0);
	QQuickWindow *window = qobject_cast<QQuickWindow*>(topLevel);
	
	window->show();
	
	int retvar = app.exec();
	
	return retvar;
}
