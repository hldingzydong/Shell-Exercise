# Global variables
BOOK=~/.addressbook
export BOOK

# 正则表达式
NAME_PATTERN="^[A-Za-z]{3,16}$"
PHONE_PATTERN="^1[3-8][0-9]{9}$"
EMAIL_PATTERN="^([0-9A-Za-z\\-]+)@([0-9a-z]+\\.[a-z]{2,3}(\\.[a-z]{2})?)$"

#######################################
#  list / search item in address book
#######################################
list_items()
{
	if [ "$#" -eq "0" ]; then
		echo "Search for: (return to list all) \c"
    	read SEARCH
    else
    	SEARCH="$@"
	fi
	
	if [ -z "${SEARCH}" ]; then
		cat ${BOOK} | while read LINE
		do
			echo ${LINE}
		done
	else
		grep -w ${SEARCH} ${BOOK} | while read ITEM
		do
			echo "${ITEM}" | tr ':' '\t'
		done
	fi
}

#######################################
#  add item to address book
#######################################
add_item()
{
	echo "Add Item: You will be prompted for 3 items:"
	echo " - Name, Phone, Email."
	echo
	echo "Name: \c"
	read NAME

	if [ ! -z ${NAME} ] && [[ ${NAME} =~ ${NAME_PATTERN} ]]; then
		grep -w -q ${NAME} ${BOOK} 
		if [ $? -eq 0 ]; then
			echo "The Name already exists"
			return
		fi
	else
		echo "You must input a name"
		return
	fi

	echo "Phone: \c"
	read PHONE 
	if [ -z ${PHONE} ]; then
		echo "You cannot input an empty Phone number"
		return
	elif !([[ ${PHONE} =~ ${PHONE_PATTERN} ]]); then
		echo "You must input a valid Phone number"
		return
	fi

	echo "Email: \c"
	read EMAIL
	if [ -z ${EMAIL} ]; then
		echo "You cannot input a empty Email address"
		return
	elif !([[ ${EMAIL} =~ ${EMAIL_PATTERN} ]]); then
		echo "You must input a valid Email address"
		return
	fi

	echo "${NAME}:${PHONE}:${EMAIL}" >> ${BOOK}
}

#######################################
#  edit item in address book
#######################################
edit_item()
{
	echo "Please input the item you want to edit: \c"
	read EDIT_ITEM

	if [ ! -z ${EDIT_ITEM} ]; then
		ITEM=`grep -w ${EDIT_ITEM} ${BOOK}`
		if [ ! -z ${ITEM} ]; then
			echo "Search: ${ITEM}" 
			# 生成原本的地址簿
			OLD_NAME=`echo ${ITEM} | cut -d ":" -f 1`
			OLD_PHONE=`echo ${ITEM} | cut -d ":" -f 2`
			OLD_EMAIL=`echo ${ITEM} | cut -d ":" -f 3`

			# 读取新的Name
			echo " Name: [ ${OLD_NAME} ] \c"
			read NEW_NAME
			if [ ! -z ${NEW_NAME} ] && [[ ${NEW_NAME} =~ ${NAME_PATTERN} ]]; then
				grep -w -q ${NEW_NAME} ${BOOK} 
				if [ $? -eq 0 ]; then
					echo "The Name already exists"
					return
				fi
			else
				echo "You must input a name"
				return
			fi

			# 读取新的Phone Number
			echo " Phone: [ ${OLD_PHONE} ] \c"
			read NEW_PHONE
			if [ -z ${NEW_PHONE} ]; then
				echo "You cannot input an empty Phone number"
				return
			elif !([[ ${NEW_PHONE} =~ ${PHONE_PATTERN} ]]); then
				echo "You must input a valid Phone number"
				return
			fi

			# 读取新的Email
			echo " Email: [ ${OLD_EMAIL} ] \c"
			read NEW_EMAIL
			if [ -z ${NEW_EMAIL} ]; then
				echo "You cannot input a empty Email address"
				return
			elif !([[ ${NEW_EMAIL} =~ ${EMAIL_PATTERN} ]]); then
				echo "You must input a valid Email address"
				return
			fi

			grep -w -v ${EDIT_ITEM} ${BOOK} > ${BOOK}.tmp
			mv ${BOOK}.tmp ${BOOK}

			echo "${NEW_NAME}:${NEW_PHONE}:${NEW_EMAIL}" >> ${BOOK}
		fi
	fi
}


#######################################
#  remove item from address book
#######################################
remove_item()
{
	echo "Please input the item you want to remove: \c"
	read DELETE_ITEM
	if [ ! -z ${DELETE_ITEM} ]; then
		grep -w -q ${DELETE_ITEM} ${BOOK}

		if [ $? -eq 0 ]; then
			grep -w ${DELETE_ITEM} ${BOOK} | while read TMP_ITEM
			do
				echo "${TMP_ITEM}" | tr ':' '\t'
			done

			echo "Make sure to delete? (Y/N) \c"
			read OPTION

			if [ ! -z ${OPTION} ];then
				if [ ${OPTION} = "Y" -o ${OPTION} = "y" ]; then
					grep -w -v ${DELETE_ITEM} ${BOOK} > ${BOOK}.tmp
					mv ${BOOK}.tmp ${BOOK}
				fi
			fi
		else
			echo "No such item"
		fi
	fi
}
