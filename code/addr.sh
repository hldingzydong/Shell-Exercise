#!/bin/sh

. ./addr_lib.sh

# 展示menu
show_menu()
{
  # Called by do_menu
  
  echo
  echo
  echo
  echo
  echo "-- Address Book --"
  echo "1. List / Search"
  echo "2. Add"
  echo "3. Edit"
  echo "4. Remove"
  echo "q. Quit"
  echo "Enter your selection: \c"
}


do_menu()
{
	while :
	do
		show_menu
		read USER_OPTION
		case ${USER_OPTION} in
			1)
				list_items
				;;

			2)
				add_item
				;;
			3)
				edit_item
				;;
			4)
				remove_item
				;;
			q)
				echo "See You Again!"
				break
				;;
			*)
				echo "Please enter a right option"
				;;
		esac
	done
}



#######################################
#  Main  Menu
#######################################
if [ ! -f ${BOOK} ]; then
	echo "Creating New Book ..."
	touch ${BOOK}
fi

if [ ! -r ${BOOK} ]; then
	echo "Error: Book is not readable"
	exit 1
fi

if [ ! -w ${BOOK} ]; then
	echo "Error: Book is not writable"
	exit 2
fi


echo "Welcome to Address Book"
do_menu
