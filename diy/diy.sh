## 修改自SuperManito，仅供私人使用
## Modified:2021-3-27

##############################  作  者  昵  称  （必填）  ##############################
# 使用空格隔开
author_list="shylocks whyour 799953468 i-chenzhe"

##############################  作  者  脚  本  地  址  URL  （必填）  ##############################
# 例如：https://raw.sevencdn.com/whyour/hundun/master/quanx/jx_nc.js
# 1.从作者库中随意挑选一个脚本地址，每个作者的地址添加一个即可，无须重复添加
# 2.将地址最后的 “脚本名称+后缀” 剪切到下一个变量里（my_scripts_list_xxx）

## 测试使用github地址
scripts_base_url_1=https://raw.githubusercontent.com/ZackQQ/Jiaoben_Keep/main/diy/diy_scripts/
scripts_base_url_2=https://raw.githubusercontent.com/ZackQQ/Jiaoben_Keep/main/diy/diy_scripts/
scripts_base_url_3=https://raw.githubusercontent.com/ZackQQ/Jiaoben_Keep/main/diy/diy_scripts/
scripts_base_url_4=https://raw.githubusercontent.com/ZackQQ/Jiaoben_Keep/main/diy/diy_scripts/

## 添加更多脚本地址URL示例：scripts_base_url_3=https://raw.sevencdn.com/whyour/hundun/master/quanx/

##############################  作  者  脚  本  名  称  （必填）  ##############################
# 将相应作者的脚本填写到以下变量中
my_scripts_list_1="jd_jdaxc.js jd_xxl_gh.js"
my_scripts_list_2="jd_factory_component.js"
my_scripts_list_3="jd_paopao.js"
my_scripts_list_4="jd_entertainment.js jd_shake.js jd_marketLottery.js jd_superDay.js jd_xmf.js jd_wish.js jd_lenovo.js jd_oneplus.js jd_mgold.js jd_grassy.js jd_sister.js"

## 活动脚本名称1：东东爱消除、个护爱消除
## 活动脚本名称2：京喜工厂Plus
## 活动脚本名称3：京东泡泡大战
## 活动脚本名称4：百变大咖秀、超级摇一摇、京东超市-大转盘、超级品类日、众筹许愿池、科技打造品质生活、一加盲盒、金口碑奖投票、答题赢京豆、乘风破浪的姐姐

## 由于CDN代理无法实时更新文件内容，目前使用本人的脚本收集库以解决不能访问 Github 的问题

##############################  随  机  函  数  ##############################
rand() {
  min=$1
  max=$(($2 - $min + 1))
  num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
  echo $(($num % $max + $min))
}
cd ${ShellDir}
index=1
for author in $author_list; do
  echo -e "开始下载 $author 的活动脚本："
  echo -e ''
  # 下载my_scripts_list中的每个js文件，重命名增加前缀"作者昵称_"，增加后缀".new"
  eval scripts_list=\$my_scripts_list_${index}
  #echo $scripts_list
  eval url_list=\$scripts_base_url_${index}
  #echo $url_list
  for js in $scripts_list; do
    eval url=$url_list$js
    echo $url
    eval name=$js
    echo $name
    wget -q --no-check-certificate $url -O scripts/$name.new

    # 如果上一步下载没问题，才去掉后缀".new"，如果上一步下载有问题，就保留之前正常下载的版本
    # 随机添加个cron到crontab.list
    if [ $? -eq 0 ]; then
      mv -f scripts/$name.new scripts/$name
      echo -e "更新 $name 完成...\n"
      croname=$(echo "$name" | awk -F\. '{print $1}')
      script_date=$(cat scripts/$name | grep "http" | awk '{if($1~/^[0-59]/) print $1,$2,$3,$4,$5}' | sort | uniq | head -n 1)
      if [ -z "${script_date}" ]; then
        cron_min=$(rand 1 59)
        cron_hour=$(rand 7 9)
        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${cron_min} ${cron_hour} * * * bash ${ShellDir}/jd.sh $croname" ${ListCron}
      else
        [ $(grep -c "$croname" ${ListCron}) -eq 0 ] && sed -i "/hangup/a${script_date} bash ${ShellDir}/jd.sh $croname" ${ListCron}
      fi
    else
      [ -f scripts/$name.new ] && rm -f scripts/$name.new
      echo -e "更新 $name 失败，使用上一次正常的版本...\n"
    fi
  done
  index=$(($index + 1))
done

##############################  删  除  失  效  的  活  动  脚  本  ##############################
## 删除旧版本失效的活动示例： rm -rf ${ScriptsDir}/jd_test.js
rm -rf ${ScriptsDir}/jd_axc.js
rm -rf ${ScriptsDir}/jd_shakeBean.js
rm -rf ${ScriptsDir}/jd_super5G.js
rm -rf ${ScriptsDir}/jd_mother_jump.js
rm -rf ${ScriptsDir}/jd_city_cash.js