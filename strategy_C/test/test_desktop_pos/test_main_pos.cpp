/**
 * sudo apt install python-pip
 * pip install -U platformio
 * export PATH=$PATH:~/.platformio/penv/bin
 *
 * pio run (pour build)
 * https://docs.platformio.org/en/latest/plus/unit-testing.html#unit-testing
 */

#include <Pos.h>
#include <Dir.h>
#include <unity.h>
#include <Vector.h>

Dir dir = left;

void test_class_Pos(void)
{
  Pos pos_1(1,2);
  TEST_ASSERT_EQUAL(1, pos_1.x);
  TEST_ASSERT_EQUAL(2, pos_1.y);
  Pos pos_2(pos_1);
  TEST_ASSERT_EQUAL(1, pos_2.x);
  TEST_ASSERT_EQUAL(2, pos_2.y);
}

void test_function_mod2Pi(void)
{
  TEST_ASSERT_EQUAL(mod2Pi(2*M_PI), 0);
  TEST_ASSERT_EQUAL(mod2Pi(-5), 2*M_PI-5);
  TEST_ASSERT_EQUAL(mod2Pi(-42), 14*M_PI-42);
}

void test_function_is_around(void)
{
  Pos pos_1(100, 450);
  Pos pos_2(90 , 350);
  TEST_ASSERT_EQUAL(false, pos_1.is_around(pos_2, 100));
  TEST_ASSERT_EQUAL(true , pos_1.is_around(pos_2, 120));

  Pos pos_3(462, 918);
  Pos pos_4(632, 475);
  TEST_ASSERT_EQUAL(false, pos_3.is_around(pos_4, 420));
  TEST_ASSERT_EQUAL(true , pos_3.is_around(pos_4, 640));

  for (int d = 1; d < 1000; d++)
    TEST_ASSERT_EQUAL(pos_4.is_around(pos_3, d), pos_3.is_around(pos_4, d));
}

void test_function_is(void)
{
  Pos pos_1(100, 300);
  TEST_ASSERT_EQUAL(true, pos_1.is(pos_1));

  Pos pos_2(pos_1);
  TEST_ASSERT_EQUAL(true, pos_1.is(pos_2));
  TEST_ASSERT_EQUAL(true, pos_2.is(pos_1));

  Pos pos_3(100, 300);
  TEST_ASSERT_EQUAL(true, pos_1.is(pos_3));
  TEST_ASSERT_EQUAL(true, pos_3.is(pos_1));

  Pos pos_4(20, 40);
  TEST_ASSERT_EQUAL(false, pos_1.is(pos_4));
  TEST_ASSERT_EQUAL(false, pos_4.is(pos_1));
}

void test_function_dist(void)
{
  Pos pos_1(100, 200);
  Pos pos_2(100, 300);
  TEST_ASSERT_EQUAL(100, pos_1.dist(pos_2));
  TEST_ASSERT_EQUAL(100, pos_2.dist(pos_1));

  Pos pos_3(165, 746);
  Pos pos_4(127, 974);
  TEST_ASSERT_EQUAL_FLOAT(231.145, pos_3.dist(pos_4));
  TEST_ASSERT_EQUAL_FLOAT(231.145, pos_4.dist(pos_3));
}

void test_function_angle(void)
{
  Pos pos_1(148, 362);
  Pos pos_2(569, 23 );
  TEST_ASSERT_EQUAL_FLOAT(5.605266, pos_1.angle(pos_2));
  TEST_ASSERT_EQUAL_FLOAT(pos_1.angle(pos_2), mod2Pi(pos_2.angle(pos_1)+M_PI));
  TEST_ASSERT_EQUAL_FLOAT(pos_2.angle(pos_1), mod2Pi(pos_1.angle(pos_2)+M_PI));
}

void test_function_closer(void)
{
  Pos pos(500, 125);
  Pos pos_0(847, 165);
  Pos pos_1(452, 364);
  Pos pos_2(156, 515);
  Pos pos_3(841, 51);
  Pos pos_4(165, 654);
  Pos pos_5(541, 65);
  Pos storage_pos[6];
  Vector<Pos> vector(storage_pos);
  vector.push_back(pos_0);
  vector.push_back(pos_1);
  vector.push_back(pos_2);
  vector.push_back(pos_3);
  vector.push_back(pos_4);
  vector.push_back(pos_5);
  TEST_ASSERT_EQUAL(5, (pos.closer(vector)));
}

//pas compris
void test_function_on_arena(void)
{
  Pos pos_left_true(100,500);
  dir = left;
  TEST_ASSERT_EQUAL(true, pos_left_true.on_arena(0));

}

void test_function_get_mid(void)
{
  Pos pos_1(100,200);
  Pos pos_2(100,300);
  TEST_ASSERT_EQUAL(true, (100 == pos_1.get_mid(pos_2)->x) &&
                          (250 == pos_1.get_mid(pos_2)->y));
  TEST_ASSERT_EQUAL(true, (pos_2.get_mid(pos_1)->x == pos_1.get_mid(pos_2)->x) &&
                          (pos_2.get_mid(pos_1)->y == pos_1.get_mid(pos_2)->y));

  Pos pos_3(158,51);
  Pos pos_4(489,496);
  TEST_ASSERT_EQUAL(true, (323.5 == pos_3.get_mid(pos_4)->x) &&
                          (273.5 == pos_3.get_mid(pos_4)->y));
  TEST_ASSERT_EQUAL(true, (pos_4.get_mid(pos_3)->x == pos_3.get_mid(pos_4)->x) &&
                          (pos_3.get_mid(pos_4)->y == pos_3.get_mid(pos_4)->y));
}

void test_operators(void)
{
  Pos pos_1(156, 468);
  Pos pos_2(156, 468);
  TEST_ASSERT_EQUAL(true, pos_1 == pos_2);
  TEST_ASSERT_EQUAL(true, pos_2 == pos_1);

  Pos pos_3(488,14);
  TEST_ASSERT_EQUAL(true, pos_1 != pos_3);
  TEST_ASSERT_EQUAL(true, pos_3 != pos_1);
}

int main(int argc, char* argv[])
{
  UNITY_BEGIN();
  RUN_TEST(test_class_Pos);
  RUN_TEST(test_function_mod2Pi);
  RUN_TEST(test_function_is_around);
  RUN_TEST(test_function_is);
  RUN_TEST(test_function_dist);
  RUN_TEST(test_function_angle);
  RUN_TEST(test_function_closer);
  RUN_TEST(test_function_on_arena);
  RUN_TEST(test_function_get_mid);
  RUN_TEST(test_operators);
  UNITY_END();
}
