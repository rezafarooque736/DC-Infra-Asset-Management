from datetime import datetime
from flask import (
    Flask,
    render_template,
    request,
    redirect,
    Response,
    session,
    url_for,
    jsonify,
)
import re
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2
import psycopg2.extras
import pandas as pd
from flask.helpers import flash
import uuid
from flask_mail import Mail, Message
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
mail = Mail(app)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY")

# mail Configuration
app.config["MAIL_SERVER"] = os.getenv("MAIL_SERVER")
app.config["MAIL_PORT"] = os.getenv("MAIL_PORT")
app.config["MAIL_USE_SSL"] = False
app.config["MAIL_USE_TLS"] = True
app.config["MAIL_DEBUG"] = True
app.config["MAIL_USERNAME"] = os.getenv("MAIL_USERNAME")
app.config["MAIL_PASSWORD"] = os.getenv("MAIL_PASSWORD")
mail = Mail(app)


def con():
    global connection, cursor
    try:
        # establishing the connection
        connection = psycopg2.connect(
            host=os.getenv("DB_HOST_SERVER"),
            port=os.getenv("DB_PORT"),
            database=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD_LOCAL"),
        )
        print("Connected")
        cursor = connection.cursor(cursor_factory=psycopg2.extras.DictCursor)
    except Exception as e:
        print("I'munable to connect to the database", e)


def rack_details_image_data():
    con()
    sql_code1 = 'SELECT * FROM dc_infra_table ORDER BY "row","rack";'
    cursor.execute(sql_code1)
    data1 = cursor.fetchall()
    rack_details = []
    count = 0
    for row1 in range(1, 7):
        if row1 == 3:
            for rack1 in range(0, 14):
                available = False
                for oneRow in data1:
                    if oneRow[1] == row1 and oneRow[2] == rack1:
                        rack_details.append(oneRow[3])
                        count += 1
                        available = True
                        break
                if available == False:
                    rack_details.append("empty")
        else:
            for rack1 in range(0, 19):
                available = False
                for oneRow in data1:
                    if oneRow[1] == row1 and oneRow[2] == rack1:
                        rack_details.append(oneRow[3])
                        count += 1
                        available = True
                        break
                if available == False:
                    rack_details.append("empty")
    cursor.close()
    connection.close()
    return data1, rack_details


@app.route("/", methods=["GET", "POST"])
def index():
    # Check if user is loggedin
    if "loggedin" in session:
        # User is loggedin show them the Logged in home page
        return redirect(url_for("showAll_datacenter"))
    else:
        data1, rack_details = rack_details_image_data()
        return render_template("index.html", data=data1, rack_details=rack_details)


@app.route("/login", methods=["GET", "POST"])
def login():
    if "loggedin" in session:
        # User is loggedin show them the Loggedin home page
        return redirect(url_for("showAll_datacenter"))
    else:
        # Check if "username" and "password" POST requests exist (user submitted form)
        if request.method == "POST":
            # if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
            con()
            username = request.form["username"]
            password = request.form["password"]

            # Check if account exists using PostgreSQL
            cursor.execute(
                f"SELECT * FROM users WHERE \"username\"='{username}' OR \"email\"='{username}' OR \"mobile_number\"='{username}';"
            )
            # Fetch one record and return result
            account = cursor.fetchone()

            if account:
                password_from_db = account[5]
                # If account exists in users table in out database
                if check_password_hash(password_from_db, password):
                    # Create session data, we can access this data in other routes
                    session["loggedin"] = True
                    session["name"] = account[1]
                    now = datetime.now()
                    date_time = now.strftime("%d/%m/%Y, %H:%M:%S")
                    # dd/mm/YY H:M:S format
                    cursor.execute(
                        f'INSERT INTO "login_history" ("fullname", "mobile_number", "email", "Date_Time") VALUES(\'{account[1]}\',\'{account[2]}\',\'{account[3]}\',\'{date_time}\')'
                    )
                    connection.commit()
                    # return redirect(url_for('index'))
                    return redirect(url_for("login"))
                else:
                    # Account doesnt exist or username/password incorrect
                    flash("Incorrect username/password")
            else:
                # Account doesnt exist or username/password incorrect
                flash("User not exist. Please, Create New Account.")
            cursor.close()
            connection.close()
        return render_template("login.html", title="Login")


@app.route("/new-user", methods=["POST", "GET"])
def newUser():
    if "loggedin" in session:
        # User is loggedin show them the Loggedin home page
        return redirect(url_for("showAll_datacenter"))
    else:
        if request.method == "POST":
            con()
            # Take input from html file, from user input
            email = request.form["email"]
            token = str(uuid.uuid4())
            # Check email in Database, and fetch users data, if availabble in database
            cursor.execute(f"SELECT * FROM users WHERE \"email\"='{email}';")
            account = cursor.fetchone()
            if account:
                flash("Email is already registered, Please use different one.")
            elif not re.match(r"[A-Za-z0-9._%+-]+@railtelindia\.com$", email):
                flash("Invalid email address. Please, use railtelindia mail only.")
            else:
                cursor.execute(
                    f"SELECT * FROM register_temp WHERE \"email\"='{email}';"
                )
                email_registered = cursor.fetchone()
                if email_registered:
                    cursor.execute(
                        f'UPDATE "register_temp" SET "token"=\'{token}\' WHERE "email"=\'{email}\';'
                    )
                    connection.commit()
                else:
                    cursor.execute(
                        f'INSERT INTO "register_temp" ("email", "token") VALUES(\'{email}\', \'{token}\');'
                    )
                    connection.commit()

                msg = Message(
                    subject="New User Registration - DC Infra Asset Management",
                    sender="fp@railtelindia.com",
                    recipients=[email],
                )
                msg.body = render_template(
                    "sent_register.html", token=token, name=email
                )
                mail.send(msg)
                flash(f"{email}", "success")
                session["email"] = email
                return render_template("new_user.html", email_correct="yes")
            cursor.close()
            connection.close()
        return render_template("new_user.html", title="Registration request form")


@app.route("/register/<token>", methods=["GET", "POST"])
def register(token):
    if "loggedin" in session:
        # User is loggedin show them the Loggedin home page
        return redirect(url_for("showAll_datacenter"))
    else:
        # Check if "username", "password" and "email" POST requests exist (user submitted form)
        if request.method == "POST":
            # if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form:
            con()
            # Create variables for easy access
            fullname = request.form["fullname"]
            mobile_number = request.form["mobile_number"]
            username = request.form["username"]
            email = session["email"]
            password = request.form["password"]
            hashed_password = generate_password_hash(password)
            token1 = str(uuid.uuid4())

            # Check token in Database, and fetch users data, if availabble in database
            cursor.execute(f"SELECT * FROM register_temp WHERE \"token\"='{token}';")
            user = cursor.fetchone()

            if user:
                cursor.execute(
                    f'UPDATE "register_temp" SET "token"=\'{token1}\' WHERE "token"=\'{token}\';'
                )
                connection.commit()

                cursor.execute(
                    f'INSERT INTO "users" ("fullname", "mobile_number", "email", "username", "password", "token") VALUES(\'{fullname}\',\'{mobile_number}\',\'{email}\',\'{username}\',\'{hashed_password}\',\'{token1}\');'
                )
                connection.commit()
                print("after users insert commit")

                cursor.execute(f"SELECT * FROM users WHERE \"email\"='{email}';")
                account = cursor.fetchone()
                print(account)

                password_from_db = account[5]
                print(password_from_db)

                if check_password_hash(password_from_db, password):
                    # Create session data, we can access this data in other routes
                    session["loggedin"] = True
                    session["name"] = account[1]
                    now = datetime.now()
                    date_time = now.strftime("%d/%m/%Y, %H:%M:%S")
                    # dd/mm/YY H:M:S format
                    cursor.execute(
                        f'INSERT INTO "login_history" ("fullname", "mobile_number", "email", "Date_Time") VALUES(\'{account[1]}\',\'{account[2]}\',\'{account[3]}\',\'{date_time}\')'
                    )
                    connection.commit()
                    return redirect(url_for("login"))
                cursor.close()
                connection.close()
                flash("Your password updated successfully", "success")
                return redirect("/login")
            else:
                flash("your token has expired", "danger")
                return redirect("/new-user")
        return render_template(
            "register.html", title="Registeration Page", email=session["email"]
        )


@app.route("/forgot", methods=["POST", "GET"])
def forgot():
    if "loggedin" in session:
        # User is loggedin show them the Loggedin home page
        return redirect(url_for("showAll_datacenter"))
    else:
        if request.method == "POST":
            con()
            # Take input from html file, from user input
            email = request.form["email"]
            token = str(uuid.uuid4())

            # Check email in Database, and fetch users data, if availabble in database
            cursor.execute(f"SELECT * FROM users WHERE \"email\"='{email}';")
            account = cursor.fetchone()

            if account:
                # Fetch one record and return result
                msg = Message(
                    subject="Forgot password request - Patch Status",
                    sender="fp@railtelindia.com",
                    recipients=[email],
                )
                msg.body = render_template(
                    "sent_forgot.html", token=token, name=account[1]
                )
                mail.send(msg)
                cursor.execute(
                    f'UPDATE "users" SET "token"=\'{token}\' WHERE "email"=\'{email}\';'
                )
                connection.commit()
                email_address = account[3]
                flash(f"{email_address}", "success")
                session["email_address"] = email_address
                # return redirect(url_for('.forgot'))
                return render_template("forgot.html", email_correct="yes")
            else:
                flash("You are not Registered", "danger")
            cursor.close()
            connection.close()
        return render_template("forgot.html", title="Forgot password request form")


@app.route("/reset/<token>", methods=["POST", "GET"])
def reset(token):
    if "loggedin" in session:
        # User is loggedin show them the Loggedin home page
        return redirect(url_for("showAll_datacenter"))
    else:
        if request.method == "POST":
            con()
            # Take input from html file, from user input
            password = request.form["password"]
            hashed_password = generate_password_hash(password)
            token1 = str(uuid.uuid4())
            # Check token in Database, and fetch users data, if availabble in database
            cursor.execute(f"SELECT * FROM users WHERE \"token\"='{token}';")
            user = cursor.fetchone()
            if user:
                cursor.execute(
                    f'UPDATE "users" SET "token"=\'{token1}\', "password"=\'{hashed_password}\' WHERE "token"=\'{token}\';'
                )
                connection.commit()
                cursor.close()
                connection.close()
                flash("Your password updated successfully", "success")
                # return redirect('/login')
                return redirect(url_for("login"))
            else:
                flash("your token has expired", "danger")
                return redirect("/")
        return render_template(
            "reset.html", title="Reset password", email=session["email_address"]
        )


@app.route("/logout")
def logout():
    if "loggedin" in session:
        # Remove session data, this will log the user out
        if session.get("loggedin"):
            del session["loggedin"]
            del session["name"]
        # Redirect to login page
        # return redirect(url_for('index'))
        return redirect(url_for("login"))
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


@app.route("/one-row-rack-details/<int:row>/<int:rack>/<string:display_type>")
def one_row_rack_details(row, rack, display_type):
    con()
    try:
        sql_code1 = 'SELECT * FROM dc_infra_table WHERE "row" = %s AND "rack" = %s;'
        values1 = (row, rack)
        cursor.execute(sql_code1, values1)
        data = cursor.fetchall()
        cursor.close()
        connection.close()
        print(jsonify(data))
        if display_type == "hovered":
            return jsonify({'data':data, 'name1':'reza'})
        return render_template("one_row_rack_details.html", row_rack_data=data)
    except:
        return render_template("error.html", row=row, rack=rack)


@app.route("/showAll-dc-infra", methods=["GET", "POST"])
def showAll_datacenter():
    if "loggedin" in session:
        data1, rack_details = rack_details_image_data()
        return render_template(
            "showAll_datacenter.html", data=data1, rack_details=rack_details
        )
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


@app.route("/deleted-data", methods=["GET", "POST"])
def deleted_data():
    if "loggedin" in session:
        con()
        sql_code1 = 'SELECT * FROM deleted_data ORDER BY "SNo";'
        cursor.execute(sql_code1)
        data1 = cursor.fetchall()
        # print(data1)
        cursor.close()
        connection.close()
        return render_template("deleted_data.html", data=data1)
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


@app.route("/loginHistory")
def loginHistory():
    if "loggedin" in session:
        con()
        cursor.execute('SELECT * FROM login_history order by "SNo" DESC;')
        user_details = cursor.fetchall()
        cursor.close()
        connection.close()
        return render_template("login_history.html", user_details=user_details)
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


# add new row from showAll daatcenter configuration


@app.route("/addDatacenter", methods=["POST", "GET"])
def add_datacenter():
    if "loggedin" in session:
        if request.method == "POST":
            con()
            row = request.form["row"]
            rack = request.form["rack"]
            service_type = request.form["service_type"]
            customer_name = request.form["customer_name"]
            customer_project = request.form["customer_project"]
            ci_type = request.form["ci_type"]
            asset_tag = request.form["asset_tag"]
            oem = request.form["oem"]
            model = request.form["model"]
            serial_number = request.form["serial_number"]
            hostname = request.form["hostname"]
            ip_mgmt = request.form["ip_mgmt"]
            ipmi_ilo = request.form["ipmi_ilo"]
            amc_start_date = request.form["amc_start_date"]
            amc_end_date = request.form["amc_end_date"]
            remark = request.form["remark"]
            remark = remark.replace("'", "`")
            created_by = session["name"]
            now = datetime.now()
            creation_date_time = now.strftime("%d/%m/%Y, %H:%M:%S")

            if row == "":
                msg = "Please Input row no"
            elif rack == "":
                msg = "Please Input rack no"
            elif service_type == "":
                msg = "Please Input Service Type"
            elif customer_name == "":
                msg = "Please Input Customer Name"
            elif customer_project == "":
                msg = "Please Input Customer Project"
            else:
                sql_code1 = (
                    'SELECT "SNo" FROM dc_infra_table ORDER BY "SNo" DESC LIMIT 1;'
                )
                cursor.execute(sql_code1)
                sl_no = cursor.fetchone()
                if sl_no == None:
                    sl_no = 1
                else:
                    sl_no = sl_no[0] + 1

                sql_code2 = 'INSERT INTO dc_infra_table("SNo", "row", "rack", "service_type", "customer_name", "customer_project", "ci_type", "asset_tag", "oem", "model", "serial_number", "hostname", "ip_mgmt", "ipmi_ilo", "amc_start_date", "amc_end_date","remark", created_by, creation_date_time) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
                values2 = (
                    sl_no,
                    row,
                    rack,
                    service_type,
                    customer_name,
                    customer_project,
                    ci_type,
                    asset_tag,
                    oem,
                    model,
                    serial_number,
                    hostname,
                    ip_mgmt,
                    ipmi_ilo,
                    amc_start_date,
                    amc_end_date,
                    remark,
                    created_by,
                    creation_date_time,
                )
                cursor.execute(sql_code2, values2)
                connection.commit()
                flash("New record created successfully.")
                cursor.close()
                connection.close()
        return render_template("addDatacenter.html")
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


@app.route("/updateDataCenter/<int:sno1>", methods=["GET", "POST"])
def updateRailTel(sno1):
    if "loggedin" in session:
        if request.method == "POST":
            con()
            row = request.form["row"]
            rack = request.form["rack"]
            service_type = request.form["service_type"]
            customer_name = request.form["customer_name"]
            customer_project = request.form["customer_project"]
            ci_type = request.form["ci_type"]
            asset_tag = request.form["asset_tag"]
            oem = request.form["oem"]
            model = request.form["model"]
            serial_number = request.form["serial_number"]
            hostname = request.form["hostname"]
            ip_mgmt = request.form["ip_mgmt"]
            ipmi_ilo = request.form["ipmi_ilo"]
            amc_start_date = request.form["amc_start_date"]
            amc_end_date = request.form["amc_end_date"]
            remark = request.form["remark"]
            remark = remark.replace("'", "`")
            created_by = session["name"]
            now = datetime.now()
            creation_date_time = now.strftime("%d/%m/%Y, %H:%M:%S")

            sql_code1 = 'UPDATE dc_infra_table SET "row"=%s, "rack"=%s, "service_type"=%s, "customer_name"=%s, "customer_project"=%s, "ci_type"=%s, "asset_tag"=%s, "oem"=%s, "model"=%s, "serial_number"=%s, "hostname"=%s, "ip_mgmt"=%s, "ipmi_ilo"=%s, "amc_start_date"=%s, "amc_end_date"=%s, "remark"=%s, "created_by"=%s,"creation_date_time"=%s WHERE "SNo"=%s;'
            values1 = (
                row,
                rack,
                service_type,
                customer_name,
                customer_project,
                ci_type,
                asset_tag,
                oem,
                model,
                serial_number,
                hostname,
                ip_mgmt,
                ipmi_ilo,
                amc_start_date,
                amc_end_date,
                remark,
                created_by,
                creation_date_time,
                sno1,
            )
            cursor.execute(sql_code1, values1)
            connection.commit()
            cursor.close()
            connection.close()
            flash("Record Updated successfully")
            cursor.close()
            connection.close()
            return redirect(url_for("showAll_datacenter"))
        return render_template("updateDataCenter.html", sno1=sno1)
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


#! getdatabaseRailTel


@app.route("/getdatabaseDatacenter", methods=["GET", "POST"])
def getdatabaseDatacenter():
    if "loggedin" in session:
        if request.method == "POST":
            con()
            sno1 = request.form["sno1"]
            sql_code1 = 'SELECT * FROM dc_infra_table WHERE "SNo"=%s;'
            values1 = (sno1,)
            cursor.execute(sql_code1, values1)
            data = cursor.fetchone()
            data = {
                "row": data[1],
                "rack": data[2],
                "service_type": data[3],
                "customer_name": data[4],
                "customer_project": data[5],
                "ci_type": data[6],
                "asset_tag": data[7],
                "oem": data[8],
                "model": data[9],
                "serial_number": data[10],
                "hostname": data[11],
                "ip_mgmt": data[12],
                "ipmi_ilo": data[13],
                "amc_start_date": data[14],
                "amc_end_date": data[15],
                "remark": data[16],
            }
            cursor.close()
            connection.close()
            return jsonify(data)
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


#! deleteRailwaySupport


@app.route("/deleteDataCenter/<int:sl_no>/<reason>")
def deleteDataCenter(sl_no, reason):
    if "loggedin" in session:
        con()
        sql_code4 = 'SELECT * FROM dc_infra_table WHERE "SNo"=%s;'
        values4 = (sl_no,)
        cursor.execute(sql_code4, values4)
        data4 = cursor.fetchone()

        row = data4[1]
        rack = data4[2]
        service_type = data4[3]
        customer_name = data4[4]
        customer_project = data4[5]
        ci_type = data4[6]
        asset_tag = data4[7]
        oem = data4[8]
        model = data4[9]
        serial_number = data4[10]
        hostname = data4[11]
        ip_mgmt = data4[12]
        ipmi_ilo = data4[13]
        amc_start_date = data4[14]
        amc_end_date = data4[15]
        old_remark = data4[16]
        old_remark = old_remark.replace("'", "`")
        deleted_by = session["name"]
        now = datetime.now()
        date_time = now.strftime("%d/%m/%Y, %H:%M:%S")
        deletion_date_time = date_time
        deletion_reason = reason

        sql_code2 = 'SELECT "SNo" FROM deleted_data ORDER BY "SNo" DESC LIMIT 1;'
        cursor.execute(sql_code2)
        sno = cursor.fetchone()
        if sno == None:
            sno = 1
        else:
            sno = sno[0] + 1

        sql_code3 = 'INSERT INTO deleted_data ("SNo", "row", "rack", "service_type", "customer_name", "customer_project", "ci_type", "asset_tag", "oem", "model", "serial_number", "hostname", "ip_mgmt", "ipmi_ilo", "amc_start_date", "amc_end_date","old_remark","deleted_by","date_time","deletion_reason") VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)'
        values2 = (
            sno,
            row,
            rack,
            service_type,
            customer_name,
            customer_project,
            ci_type,
            asset_tag,
            oem,
            model,
            serial_number,
            hostname,
            ip_mgmt,
            ipmi_ilo,
            amc_start_date,
            amc_end_date,
            old_remark,
            deleted_by,
            deletion_date_time,
            deletion_reason,
        )
        cursor.execute(sql_code3, values2)
        connection.commit()

        sql_code1 = 'DELETE FROM dc_infra_table WHERE "SNo" = %s'
        values1 = (sl_no,)
        cursor.execute(sql_code1, values1)
        connection.commit()

        cursor.close()
        connection.close()
        return redirect(url_for("showAll_datacenter"))
    else:
        # return redirect(url_for('index'))
        return redirect(url_for("login"))


#! /downloadRailwaySupport


@app.route("/download-dc-all/<int:row>")
def downloadDcAll(row):
    con()
    if row == 0:
        query = f'SELECT row, rack, service_type, customer_name, customer_project, ci_type, asset_tag,oem, model, serial_number, hostname, ip_mgmt, ipmi_ilo, amc_start_date, amc_end_date, remark, created_by, creation_date_time FROM dc_infra_table ORDER BY "row","rack";'
    else:
        query = f'SELECT row, rack, service_type, customer_name, customer_project, ci_type, asset_tag,oem, model, serial_number, hostname, ip_mgmt, ipmi_ilo, amc_start_date, amc_end_date, remark, created_by, creation_date_time FROM dc_infra_table WHERE "row" = {row} ORDER BY "row","rack";'
    df = pd.read_sql_query(query, connection)
    # print(df)

    with pd.ExcelWriter("Railway_support_database.xlsx", engine="xlsxwriter") as writer:
        workbook = writer.book
        myformat1 = workbook.add_format(
            {"align": "center", "valign": "vcenter", "text_wrap": True}
        )
        df.to_excel(writer, "Sheet 1", index=False)
        worksheet = writer.sheets["Sheet 1"]
        worksheet.set_column("A:B", 10, myformat1)
        worksheet.set_column("C:R", 25, myformat1)
    cursor.close()
    connection.close()
    return Response(
        open("Railway_support_database.xlsx", "rb"),
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        headers={
            "Content-Disposition": "attachment;filename=Railway_support_database.xlsx"
        },
    )
    # return render_template('work_in_progress.html')


if __name__ == "__main__":
    app.run(debug=False, host="0.0.0.0")
