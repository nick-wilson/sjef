if [[ $# -eq 1 ]]; then
    args="-n $1"
fi

eval conda env create $args -f environment.yaml
