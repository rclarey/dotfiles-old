def -docstring 'invoke fzf to search file contents' \
  ctrlf %{ %sh{
    if [ -z "$TMUX" ]; then
      echo echo only works inside tmux
    else
      FILE=`ag --nobreak --noheading . | fzf-tmux -d 15`
      if [ -n "$FILE" ]; then
        C1=`echo $FILE | sed -n 's/^\(.*\):[0-9]*:.*/\1/p'`
        C2=`echo $FILE | sed -n 's/^.*:\([0-9]*\):.*/\1/p'`
        tmux neww -a kak $C1 -e "exec ${C2}jk"
      fi
    fi
}}
