#include "../Include/QDx12Wid.h"

#include "../../Include/QtHelp/WJAPI_QtDebug.h"

QDx12Wid::QDx12Wid(QWidget *parent)
	: QWidget(parent)
{
	ui.setupUi(this);
	setAttribute(Qt::WA_PaintOnScreen, true);//if use custom draw ,need WA_PaintOnScreen be true
	setAttribute(Qt::WA_NativeWindow, true);
}

QDx12Wid::~QDx12Wid()
{
	WJAPI_Qt_DebugOut("You delete QDx12Wid!");
}
