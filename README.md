## Specification
[Shell Script Tutorial](https://www.shellscript.sh/exercises.html)

## Note
1. 正则表达式:
NAME_PATTERN="^[A-Za-z]{3,16}$"
PHONE_PATTERN="^1[3-8][0-9]{9}$"
EMAIL_PATTERN="^([0-9A-Za-z\\-]+)@([0-9a-z]+\\.[a-z]{2,3}(\\.[a-z]{2})?)$"

2. while循环中,如果是以**管道**方式读取输入流,则相当于进入到另外一个子shell，需注意变量作用范围
3. cat
4. grep -w(全字符匹配) -q(没有输出)
5. =～ 用于shell中字符串与正则匹配
6. 
```shell
cut -d ":" -f 1 # 取filed
```