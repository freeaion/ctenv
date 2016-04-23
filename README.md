----------------------------------------------------------------------------
README:         CTENV (ClearTool Environment)
----------------------------------------------------------------------------

Author:

	Yonghyun Hwang		<freeaion@gmail.com>

Directory structure:

	cs/		- global clearcase config specs used by CTENV
              two template config specs by default
	dat/		- data files used by CTENV
	doc/		- tutorial
	lib/		- lib files that CTENV uses

Introduction:

CTENV is a clearcase view management tool, which can dramatically
simplifies your daily task for clearcase view management. It provides
basic features, such as view creation/list/deletion/checkin|out. In
addition to these, it also supports highly useful features, such as
view export/import/sync/diff. CTENV's command line interface is very
user friendly and easy to learn. It only asks a user to specify what's
truly needed. It doesn't ask complicated options or settings for
clearcase at all. For example, if you want to create a new dynamic
view, "testview", w/ a config spec, "mycs", this is the command.

	$ ctenv -c -s mycs testview
	# -c says your intention creating dynamic view
	# -s specifies config spec
	# testview is the name of view

As it can be seen above, CTENV's command line interface captures your
intention, not asking geeky and complicated options. Hence, you can
learn how to use CTENV in less than an hour. :)

One of the great benefits out of using CTENV is that you can do all
these __intuitively__ on terminal in a __batch__ (w/o dealing w/ GUI
provided by clearcase) you can also easily implement your own shell
script to automate your daily tasks w/ clearcase.

CTENV provides a short tutorial. It also implements on-line manual that
shows example commands for your day-to-day tasks. Using the on-line
manual, you can simply copy and paste commands to get things done.

To get started and see the details (including prerequisite for CTENV),
please take a look at the tutorial under 'doc' directory. If you need
any comments and/or feedback on CTENV, please feel free to contact me
at <freeaion@gmail.com> Enjoy!

Yonghyun Hwang, Apr 2016.

----------------------------------------------------------------------------
