#  import pymysql.cursors
import MySQLdb


def main():
    """Connect to MariaDB sample
    :returns: TODO

    """
    conn = MySQLdb.connect(
            user='root',
            passwd='password',
            host='localhost',
            db='new_image',
            charset='utf8'
            )
    c = conn.cursor()

    #  クエリを作成
    sql = 'select * from 在庫ロボットcsv出力ビュー'
    c.execute(sql)
    print('* 在庫ロボットcsv出力ビューの一覧を表示\n')
    for row in c.fetchall():
        print(row)


main()
