Title: Project 3-1 Vi Tutorial
Purpose: Demonstrate an understanding of the Vi editor
Author: Stewart Johnston
Email: johnstons1@student.ncmich.edu

#Vi Editor

The Vi Editor, a name derived of its Visual nature, is a standard text
editor which is commonly installed on Unix-based systems. To the best of
my knowledge, Vi or some derivation of it, is a default installation on
most all linux distributions.

If one so chooses, they may install gVim, which itself is only different
in that it operates with a GUI and has more native mouse support.

##Basic operations

###Opening and closing vi and files

Vi, Vim, or gVim; any of these that are installed may be launched from
the command-line by their names as a lower-case command.

``$ vi``

If opened without an argument, the vi splash text will wait until you
begin typing before disappearing. Of special note, F1 and :h will open
the help pages. The help pages proper are a better teacher of how to use
and search the help pages than I.

A file can be opened directly by passing the filename or path as an
argument.

``$ vi some_file.txt``

Multiple files may be opened directly by passing an arbitrary number of
files, as with anything else in UNIXy command line fashion, delimited by
spaces. When this is done, vi should keep each of these files in its
buffer list, which I'll get to later. For now, invoking vi on its own or
with a single file is sufficient.

``$ vi some_file.txt ../README.md foo/bar.c``

When vi is opened, it opens by default in "normal mode". In normal mode,
all keystrokes are interpreted as commands. This should be the mode a
user returns to most often, which can most often be done by hitting the
``ESC``, escape key.

When in normal mode, the ``:`` (colon) key will drop one into
"Command-Line" mode. To quit vi, when in command-line mode, one uses
_q_uit, or for its shorthand, "q". In a couple of keystrokes, this can be
summarized as:

``:q``

If a buffer or file has any changes made to it, vi will complain if one
try to quit with edits that haven't been written. "Changes since last
write", it may say, with the followup, "type q! to quit anyway". The
exclamation point, or bang, is often used to modify commands to force
past warnings. If one opened a file in read-only mode, but have
permissions to write changes to it, the warning of read-only mode can be
bullied past with "w!". Outright errors may not be avoided.

If one has multiple windows, buffers, or tabs open, one can quit _a_ll
of them at once by appending ``a`` to the command.

``:qa!``

As preluded to earlier, ``w`` will _w_rite changes to a file. The
commands will be executed in sequence, so ``:wq`` will write and
immediately quit.

###Normal mode and navigation

Editing (moving, changing case, deletion, etc), point of fact, should be
done in normal mode when possible. My modus operandi is to hit 'esc'
when I'm not sure what mode I'm in, or when I've finished typing.
Generally I've built the reflext that if I pause my typing, I'm back in
normal mode.

While I'm on normal mode, I should cover movement. Forget the
arrow-keys, and stay on home row of the keyboard with hjkl. Again for
historical reasons, hjkl are the keys of choice for character-wise
navigation. ``h`` takes the cursor left, ``j`` goes line down, ``k``
goes line up, and ``l`` takes the cursor right. Vim does make a
distinction between display lines and numbered lines, and j and k
operate on numbered lines; if word-wrapping is turned on, then lines
will break at the right edge and wrap over to the next line on the left
edge, which creates a new display line but not a new numbered line. This
behavior can be changed in the settings, but that's an exercise for the
reader.

Vi understands a wide variety of text objects over which one can move.
They'll typically move to the next occurance by default. ``w`` targets
the next start of _w_ord, ``e`` targets the _e_nd of a word, and ``b``
targets the previous _b_eginning, it goes "backward". Most of this is
fairly alliterative, insofar as mnemonics are concerned, word, end,
back, etc.  Consider these as nouns in our language of commands, which
can be used in composition with other commands.

Searching is highly, emphasis, *highly* useful. From normal mode, a
single keystroke will drop into a command-line search prompt. Forward
slash, ``/``, searches forward through the buffer, and the question
mark, ``?``, searches backwards through the buffer. This is right next
to the natural location of the pinky-finger, so should be encouraged to
be used frequently, rather than navigating one line at a time. Upon
striking the enter key with a search term (which can be a regex
pattern), vim will go straight to the appropriate string. These can be
used as motions in commands, as well. Note that ? is accessed with
shift-/, which is a common pattern: modifying a command with the shift
key, in some cases by way of a capital, and in some cases by way of
whatever character happens to share the key. When a search term has been
used in that editing session, vi will rememeber it, and it can be
searched again easily. ``n`` will take one to the next occurance of the
search term, in whichever direction the search was made; ``N`` will take
one in the opposite direction, backward if you just searched using
``/``.

*Within the same line*, ``t`` and ``f`` may be used. To move un_t_il the
next instance of a character, use ``tc``, where c is the character being
targeted. Moving until a character will operate up to, but not
including, that character. In _f_inding a character, with ``f``, vim
will operate up to and including that character. As before, shifting and
using ``T`` or ``F`` will go backwards in the line.

Some of these motions are more obscure. The parentheses, ``(`` and
``)``, operate on sentences as they appear in english. The curly-braces,
``{`` and ``}``, are motions about paragraphs (delimited by blank
lines).

The largest motions one can make are to the beginning of the file, and
the end of the file. ``g`` is a prefix to many commands, but ``gg``,
will _g_o to the beginning of the buffer. On the other hand, ``G``, will
go to the end of the buffer. This is one of the few places where the
command isn't mirrored across shifting.

Other highly useful navigation commands include H, M, and L, which move
the cursor _H_igh, _M_iddle, and _L_ow on the screen. ``^`` here means
CTRL: ``^u`` and ``^d`` go _u_p and _d_own a have page/half screen.
``^f`` and ``^b``, meanwhile, go _f_orward and _b_ackward a full
page/screen.

###Normal mode and editing

Backspacing over text should be stricken from one's muscle-memory within
vi. In insert mode, it's normal to back over a brief mistake in a word
and keep going. In normal mode, that is an anti-pattern. To strikeout a
single character, the ``x`` key will strikeout the character under the
cursor; my mnemonic is to e_x_terminate a character. The ``d`` key
stands for _d_elete, and requires a motion to correctly operate. To
delete to the next word, for instance, ``dw`` would delete forward to
the beginning of the next word.  To _c_hange characters, ``c``, when
given a motion, will behave as "delete", and then will drop into insert
mode. Shifting these will modify their behavior.  ``D`` will delete to
the end of the line, likewise ``C`` to the end of the line before
dropping into insert mode.

Several commands can be repeated to operate on a whole line. ``dd`` will
delete the current line, and ``cc`` will, likewise, delete the line and
open insert mode.

These commands can be composed with other directives, including quantity
or muliple, and location, along with some other options depending on the
command. See the help pages on those particular commands for more
detail. For quantity, most commands accept a multiplier. Rather than
moving down 5 lines with ``jjjjj``, I would instead use ``5j`` to do so
in one shot. This can be done for almost any normal-mode command. To
delete 4 words, I might use ``d4e``. The exact position of the N number
is dependent on the command. Movement commands typically expect the
number as a prefix, like ``nj``. Commands which may be modified by a
motion usually expect the multiplier between the command and the motion.

A sequence very frequently typed on my keyboard is ``ci)``, which
changes _i_nside parentheses. One may also operate _a_round text
objects, such as deleting around brackets, which might be done with
``da]``; this will not just delete the contents between the brackets, as
with ``i``, but will grab the contents and the brackets. Behavior may
vary based on the text-object.

Copying and pasting is not accomplished the same way as most programs
behave. To copy, one _y_anks text, with ``y``, and then some motion
operator. To yank a whole line, a frequently useful command, ``yy``
works.  Also like ``D``, ``Y`` will yank the rest of the current line.
To _p_ut text, one uses ``p``, which will put text immediately after the
cursor, or on the next line, depending on the context. Using ``P``
instead will put text immediately before the cursor. Any text that is
deleted will also be yanked into the default register, in much the same
way as a typical cut operation with other text editors. A specific
register can be indicated with, literally, ``"c``, where the double
quote ``"`` is a prefix to the register, where c is an alphanumeric
character. To Delete or yank into a specific register, here the register
being 4, one must use the register as a prefix: ``"4D``

Again, the help file will cover this in more detail.

###Insert mode and adding text

Hitting ``i`` in normal mode will drop one into "insert mode". Wherever
the cursor is, the ``i`` window into insert will drop any new text
immediately prior to where one's cursor was in normal mode. Multiple
ways exist to drop into insert mode. Where ``i`` is for "insert", ``a``
is for "append", by which it means that it'll drop one's new text
immediately after where one's cursor was.

Capital letters as commands are distinct from lower-case letters.
Captial ``I`` will function similarly to ``i``, but instead of inserting
where one's cursor is, it will start inserting at the beginning of the
line, which here means before the first non-blank character on the line.
Capital ``A`` will drop one into insert mode after the last character on
the line.

Truly, insert mode is the simplest mode. There isn't a whole lot which
insert mode does, other than insert text.

###Command-Line mode
Several useful commands are to be found in vim. Command-Line mode is
opened from normal mode with ``:``, mentioned earlier.

A frequent operation in vim is to replace the current line with the
output of a command. This can be done with:

``r!cmd``

All commands can be
used in a configuration file which will run when vim is started. The
configuration file, .vimrc, is to be found in one's home directory. A
default .vimrc can be found in /etc/. Here be dragons, in that many
commands are not compatible with vi, but are new additions as of vim.

A useful command sequence to use with vim and to put in one's vimrc is:

```
:filetype on
:syntax enable
```

This will tell vim to attempt to automatically determine the filetype
being opened or edited, and to enable syntax highlighting.

Vim does have spellchecking, in the form of ``:set spell``, which will
highlight badly spelled words according to vim's dictionary files. Words
can be added to the dictionary, and incorrect words can be corrected
from normal mode with ``z=``, and then selecting the number of the correct
spelling.
