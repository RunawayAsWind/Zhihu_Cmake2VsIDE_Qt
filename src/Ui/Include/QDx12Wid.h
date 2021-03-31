#pragma once

#include <QWidget>
#include "../GenCode/UiHeader/ui_QDx12Wid.h"

class QDx12Wid : public QWidget
{
	Q_OBJECT

public:
	QDx12Wid(QWidget *parent = Q_NULLPTR);
	~QDx12Wid();

private:
	Ui::QDx12Wid ui;
};
