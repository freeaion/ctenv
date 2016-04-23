# template config spec for ctenv w/ branch

# don't change ${CTENV_CLEARCASE_BRANCH_NAME}. that will be automatically
# replaced w/ <usrid_csName_viewName> by ctenv

# please uncomment the below and put your config spec
#
#element * CHECKEDOUT
#element * .../${CTENV_CLEARCASE_BRANCH_NAME}/LATEST
#mkbranch ${CTENV_CLEARCASE_BRANCH_NAME} -override
#
#include <your_config_spec>
#
#end mkbranch ${CTENV_CLEARCASE_BRANCH_NAME}

