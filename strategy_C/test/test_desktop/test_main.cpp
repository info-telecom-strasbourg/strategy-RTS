/**
 * sudo apt install python-pip
 * pip install -U platformio
 * export PATH=$PATH:~/.platformio/penv/bin
 *
 * pio run (pour build)
 * https://docs.platformio.org/en/latest/plus/unit-testing.html#unit-testing
 */

#include "../../lib/Strategy/include/Pos.h"
#include "Pos.h"
#include <unity.h>
#include <stdio.h>
//#include <Vector.h>

void test_function_mod2Pi(void)
{
  Pos pos(1,2);
  TEST_ASSERT_EQUAL(1, pos.x);
  //TEST_ASSERT_EQUAL(1, mod2Pi(2*M_PI));
  printf("ok\n");
}

int main(int argc, char* argv[])
{
  UNITY_BEGIN();
  RUN_TEST(test_function_mod2Pi);
}
