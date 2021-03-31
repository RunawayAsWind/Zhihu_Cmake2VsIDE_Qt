#include "../Include/QtGuiZero00.h"

#include "../Include/QDx12Wid.h"
#include "../../Include/QtHelp/WJAPI_QtUi.h"
#include <thread>

QtGuiZero00::QtGuiZero00(QWidget *parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
	WJAPI_Qt_MoveWinToCenter(this,0.7,0.7,true);

	QWidget* dx12wid = new QWidget(this);
	WJAPI_Qt_SetColor(dx12wid, Qt::darkYellow);
	setCentralWidget(dx12wid);

	QDockWidget* resdwid = new QDockWidget(this);
	resdwid->setAttribute(Qt::WA_DeleteOnClose);
	addDockWidget(Qt::BottomDockWidgetArea, resdwid);
	WJAPI_Qt_SetColor(resdwid, Qt::yellow);
	resizeDocks({ resdwid }, { int(this->height() * 0.2) }, Qt::Vertical);

	QDockWidget* hierdwid = new QDockWidget(this);
	hierdwid->setAttribute(Qt::WA_DeleteOnClose);
	addDockWidget(Qt::LeftDockWidgetArea, hierdwid);
	WJAPI_Qt_SetColor(hierdwid, Qt::red);
	resizeDocks({ hierdwid }, { int(this->width() * 0.2) }, Qt::Horizontal);

	QDockWidget* inspectdwid = new QDockWidget(this);
	inspectdwid->setAttribute(Qt::WA_DeleteOnClose);
	addDockWidget(Qt::RightDockWidgetArea, inspectdwid);
	WJAPI_Qt_SetColor(inspectdwid, Qt::gray);
	resizeDocks({ inspectdwid }, { int(this->width() * 0.2) }, Qt::Horizontal);

	//th.Createfe((HWND)dx12wid->winId());
	//th.start();
}

void QtGuiZero00::closeEvent(QCloseEvent* event)
{
	//th.fe->StopRender();
}