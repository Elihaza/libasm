# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vmoreau <vmoreau@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/04/20 13:11:26 by vmoreau           #+#    #+#              #
#    Updated: 2020/08/26 14:11:41 by mabriand         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = libasm.a

NAME_BO = libasm_bonus.a

##################################### PATH #####################################

NATIV = libasm_sources/native/
BONUS = libasm_sources/bonus/

#################################### SOURCES ###################################

SRCS +=	$(NATIV)ft_strlen.s		$(NATIV)ft_strcpy.s		$(NATIV)ft_strcmp.s \
		$(NATIV)ft_strdup.s		$(NATIV)ft_read.s		$(NATIV)ft_write.s 

SRCSBO += 	$(BONUS)ft_list_push_front_bonus.s 			$(BONUS)ft_list_size_bonus.s

##################################### BASIC ####################################

CFLAGS 	= -Wall -Wextra -Werror

CC = gcc

INC = libasm_header/

HEADER = $(INC)libasm.h

OBJS = $(SRCS:.s=.o)

OBJSBO = $(SRCSBO:.s=.o)

EXE = exe

EXEBO = exebo

#################################### RULES ####################################

all : $(NAME)

.s.o:
	nasm -f macho64 $^

$(NAME) : $(OBJS) 
	ar rcs $(NAME) $(OBJS)

run : $(NAME)
	$(CC) $(CFLAGS) main.c -L ./ -lasm -o $(EXE)
	./exe

$(NAME_BO) : $(OBJS) $(OBJSBO) 
	ar rcs $(NAME_BO) $(OBJS) $(OBJSBO)

runbo : $(NAME_BO)
	$(CC) -no-pie $(CFLAGS) main_bonus.c -L ./ -lasm -o $(EXEBO)
	./exebo

clean :
	$(RM) -rf $(NAME)
	$(RM) -rf $(OBJS)
	$(RM) -rf $(NAME_BO)
	$(RM) -rf $(OBJSBO)

fclean : clean
	$(RM) exe
	$(RM) exebo

re : fclean all

.PHONY : all clean fclean re
.SILENT :