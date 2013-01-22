#include	<linux/delay.h>
int delay_cnt;
printk("mz_debug_msg %s %s %d\n", __FILE__, __func__, __LINE__);
for (delay_cnt = 0; delay_cnt < 5000; delay_cnt++) {
    udelay(1000);
}
printk("mz_debug_msg %s %s %d\n", __FILE__, __func__, __LINE__);

