git config --global credential.helper cache
if [ -z "$1" ]
  then
    echo "No commit comment supplied"
  else
    git add .
    git commit -m "$1"
    git push
fi


