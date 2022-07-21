#! /bin/bash

ALL=false;
ERRORS=false;
while [[ $# -gt 0 ]]; do
  case $1 in
    -e|--errors)
      ERRORS=true;
      shift # past argument
      shift # past value
      ;;
    -a|--all)
      ALL=true;
      shift # past argument
      shift # past value
      ;;
    esac
    done

if [[ "${ALL}" = true ]]; then
    echo "Run all";
    # Get all notebooks
    NOTEBOOKS=$(find . -name "*.ipynb");
elif [[ "${ERRORS}" = true ]]; then
    echo "Run with errors";
    # Get all notebooks
    NOTEBOOKS=$(grep -l -e "Error" *.err )
else
    echo "No valid arguments";
    exit 1;
fi

python -m spacy download en_core_web_lg

#TODO notebook order

for NOTEBOOK in ${NOTEBOOKS}
do
    if [[ "${ERRORS}" = true ]]; then
	NOTEBOOK=${NOTEBOOK%.*}.ipynb;
    fi
    LOG_NAME=${NOTEBOOK%.*}.log;
    ERROR_LOG=${NOTEBOOK%.*}.err;
    echo "RUN ${NOTEBOOK} to ${LOG_NAME} and ${ERROR_LOG}";
    jupyter nbconvert --execute --to notebook --inplace ${NOTEBOOK} 2> ${ERROR_LOG} 1> ${LOG_NAME};
done
