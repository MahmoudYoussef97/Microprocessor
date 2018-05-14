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
 
  while(1)
  {
    // Toggle pin 7 (blink a led!)
    bcm2835_gpio_set(4);
    sleep(1);
 
    bcm2835_gpio_clr(4);
    sleep(1);
  }
 
  return 0; 
}
