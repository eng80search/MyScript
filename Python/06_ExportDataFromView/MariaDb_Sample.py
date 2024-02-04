#!/usr/bin/env python
# coding: utf-8

import mariadb
import pandas as pd
import logging


def print_log_info(message)
    pass

def precheck_import_file():
    pass

def export_csv_from_db():
    pass

def import_csv_to_db():

    try:
        conn = mariadb.connect(
            user="root",
            password="password",
            host="localhost",
            database="new_image",
            port=3306,
            local_infile=1)

        cur = conn.cursor()

        message = "00: truncate table"
        logging.info(message)
        print(message)

        cur.execute(
        "truncate table test1"
        )

        print("10: insert table test1")
        # 3つのダブルコーテーションを使うと、文字列の中のシングルコーテーション
        # もしくはダブルクォーテーションはエスケープしなくても使える
        cur.execute(
            """\
            load data local infile 'C:/Temp/test1.csv' \
            into table test1 \
            fields terminated by ',' \
            ignore 1 rows \
            (item,col1,col2)
            """
        )

        print("11: insert table test1")
        # 3つのダブルコーテーションを使うと、文字列の中のシングルコーテーション
        # もしくはダブルクォーテーションはエスケープしなくても使える
        cur.execute(
            """\
            load data local infile 'C:/Temp/test2.csv' \
            into table test2 \
            fields terminated by ',' \
            ignore 1 rows \
            (code,product_name,address)
            """
        )

        conn.commit()

        conn.close()

    except Exception as e:
        print(f"Error commiting transaction: {e}")
        conn.rollback()

if __name__ == '__main__':

    precheck_import_file()
    import_csv_to_db()
    export_csv_from_db()
