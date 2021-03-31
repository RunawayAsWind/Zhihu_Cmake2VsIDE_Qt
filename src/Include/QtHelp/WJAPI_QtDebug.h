#pragma once
#include <stdarg.h>
#include <QDebug>

inline void WJAPI_Qt_DebugOut(const char* szFormat, ...)
{
	va_list pArgList;
	va_start(pArgList, szFormat);
	qDebug() << QString().vsprintf(szFormat, pArgList);
	va_end(pArgList);
}

