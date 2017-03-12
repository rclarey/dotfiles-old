from ranger.api.commands import *

import os

class re(Command):
    """:re <filename>

    Opens the specified file while refreshing the tmux window
    """

    def execute(self):
        if not self.arg(1):
            filecmd=self.fm.thisfile.path
        else:
            filecmd=self.rest(1)
        self.fm.execute_command('tmux splitw -h -c $PWD && tmux send-keys -t right C-z \'tmux killp -a -t right && kak {filecmd}\' Enter'.format(filecmd=filecmd))

    def tab(self, tabnum):
        return self._tab_directory_content()

class tf(Command):
    """:tf <filename>

    Opens the specified file in a new tmux window and switches to that window
    """

    def execute(self):
        if not self.arg(1):
            filecmd=self.fm.thisfile.path
        else:
            filecmd=self.rest(1)
        self.fm.execute_command('tmux neww -a -c $PWD kak {filecmd}'.format(filecmd=filecmd))

    def tab(self, tabnum):
        return self._tab_directory_content()

class tnf(Command):
    """:tnf <filename>

    Opens the specified file in a new tmux window but doesn't switch to that window
    """

    def execute(self):
        if not self.arg(1):
            filecmd=self.fm.thisfile.path
        else:
            filecmd=self.rest(1)
        self.fm.execute_command('tmux neww -a -d -c $PWD kak {filecmd}'.format(filecmd=filecmd))

    def tab(self, tabnum):
        return self._tab_directory_content()

