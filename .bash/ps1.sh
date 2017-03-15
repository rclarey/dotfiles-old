col180=`printf '\033[38;5;180m'`
col74=`printf '\033[38;5;74m'`
col179=`printf '\033[38;5;179m'`
col71=`printf '\033[38;5;71m'`
colrst=`printf '\033[0m'`
find_git_branch() {
  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch="detached*"
    fi
    git_branch=" ${colrst}on ${col180}$branch "
  else
    git_branch=""
  fi
}

find_git_dirty() {
  gitstat=$(git status 2>/dev/null | grep 'Untracked\|Changes\|Changed but not updated')
  git_dirty=""
  if [[ $(echo ${gitstat} | grep -c "Changes to be committed") > 0 ]]; then
  	git_dirty="${col74}●"
  fi

  if [[ $(echo ${gitstat} | grep -c "Untracked files\|Changed but not updated\|Changes not staged for commit") > 0 ]]; then
  	git_dirty="$git_dirty${col179}○"
  fi
}

cut_home() {
  dir="${PWD#$HOME}"
  if [[ "$dir" != "$PWD" ]]; then
    dir="~$dir"
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; cut_home; $PROMPT_COMMAND"

export PS1=" ${col71}\$dir\$git_branch\$git_dirty\n${colrst}➡ "
