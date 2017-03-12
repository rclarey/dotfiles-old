#!/bin/bash
dir=$1
shuf_wdw () {
  if [ "$dir" == "l" ]; then
    tmux prev
  else
    tmux next
  fi
}

shuf_pane () {
  active=`tmux lsw | ag -o [0-9]+?:.*?active`
  n=${active:0:1}
  first=`tmux lsw | ag -o [0-9]+?\(?=:\) | head -1`
  last=`tmux lsw | ag -o [0-9]+?\(?=:\) | tail -1`
  if [ "$dir" == "l" ]; then
    if [ $n -eq $first ]; then
      n=$last
    else
      n=`expr $n - 1`
    fi
  else
    if [ $n -eq $last ]; then
      n=$first
    else
      n=`expr $n + 1`
    fi
  fi
  tmux selectp -L && tmux joinp -h -t base:$n && $lastcmd
}

c=`tmux lsp | ag -o [0-9]: | wc -l`
if [ $c -gt "1" ]; then
  cur=`tmux lsp | ag [0-9]:.*?active`
  m=${cur:0:1}
  lft=`tmux lsp | ag -o [0-9]+\(?=:\) | head -1`
  if [ $m -eq $lft ]; then
    lastcmd="tmux selectp -L"
  else
    lastcmd="tmux swapp -U -d"
  fi
  shuf_pane
else
  shuf_wdw
fi
