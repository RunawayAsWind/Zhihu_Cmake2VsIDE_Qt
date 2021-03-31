#include "../../Include/QtHelp/WJAPI_QtUi.h"

void WJAPI_Qt_MoveWinToCenter(QWidget* wid, float w, float h, bool percent)
{
	int nScreenWidth, nScreenHeight;
	nScreenWidth = GetSystemMetrics(SM_CXSCREEN);
	nScreenHeight = GetSystemMetrics(SM_CYSCREEN);

	int nWidth, nHeight;
	if (percent == false)
	{
		nWidth = w;
		nHeight = h;
	}
	else
	{
		nWidth = nScreenWidth * w;
		nHeight = nScreenHeight * h;
	}
	int nLefttopx = nScreenWidth / 2 - nWidth / 2;		
	int nLefttopy = nScreenHeight / 2 - nHeight / 2;		
	wid->setGeometry(nLefttopx, nLefttopy, nWidth, nHeight);
}

void WJAPI_Qt_SetColor(QWidget* wid, QColor color)
{
	QPalette pal(wid->palette());
	pal.setColor(QPalette::Background, color);
	wid->setAutoFillBackground(true);
	wid->setPalette(pal);
}