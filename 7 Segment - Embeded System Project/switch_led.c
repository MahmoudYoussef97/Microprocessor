#include <stdio.h>
#include <bcm2835.h>

int main(int argc, char **argv)
{
  if (!bcm2835_init())
    {
      printf("bcm2835_init failed. Are you running as root??\n");
      return 1;
    }
  // Define pin 7 as output
  bcm2835_gpio_fsel(4,1);
  // Define pin 5 as input
  bcm2835_gpio_fsel(3,0);
 
  while(1)
  {
    if(bcm2835_gpio_lev(3)==1){
    bcm2835_gpio_set(4);
	}
	else{ 
    bcm2835_gpio_clr(4);
	}
  }
 
  return 0; 
}
