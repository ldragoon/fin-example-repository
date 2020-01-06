for f in photos/tin/media/images/*.jpg; do 
    b=$(basename $f .jpg);
    p=${b#*-};
    echo $f;
    echo $b;
    echo $p;
done;
