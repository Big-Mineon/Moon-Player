#include "paths.h"
#include <QDir>
#include <QCoreApplication>
#include <QStandardPaths>

QString appResourcesPath()
{
    static QString path;
    if (path.isNull())
        path = QCoreApplication::applicationDirPath().replace("/MacOS", "/Resources");
    return path;
}


QString userResourcesPath()
{
    static QString path;
    if (path.isNull())
        path = QDir::homePath() + "/Library/Application Support/MoonPlayer";
    return path;
}

//get ffmpeg's file path
QString ffmpegFilePath()
{
    static QString filename;
    if (filename.isNull())
        filename = QCoreApplication::applicationDirPath() + "/ffmpeg";
    return filename;
}
