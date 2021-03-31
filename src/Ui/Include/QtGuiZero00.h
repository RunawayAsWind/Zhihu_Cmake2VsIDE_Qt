#pragma once

#include <QtWidgets/QMainWindow>
#include "../GenCode/UiHeader/ui_QtGuiZero00.h"

//#include "../UserCode/Include/Dx12/Render/BaseFrameWork/Frame_Empty_Thread.h"
#include <QCloseEvent> 

class QtGuiZero00 : public QMainWindow
{
	Q_OBJECT

public:
	QtGuiZero00(QWidget* parent = Q_NULLPTR);
	//Frame_Empty_Thread th;

private:
	Ui::QtGuiZero00Class ui;

protected:
	void closeEvent(QCloseEvent* event);
};
