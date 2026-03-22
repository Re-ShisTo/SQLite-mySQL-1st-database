const mysql = require("mysql2/promise");

async function main() {
  const db = await mysql.createConnection({
    host: "127.0.0.1",
    user: "root",
    password: "#CP77#7053R#",
    database: "mySQL1",
  });

  try {
    await db.execute(`
        create table if not exists users(
        id int auto_increment primary key,
        name text,
        email text
        )
    `);

    const sampleUsers = [
      ["Shista Chakma", "shistachakma@email.com"],
      ["Anil Ranjan Chakma", "anilranjanchakma@email.com"],
      ["Joyeta Ranjan Chakma", "joyetaranjanchakma@email.com"],
      ["Purba Ranjan Chakma", "purbaranjanchakma@email.com"],
      ["Mintuni Ranjan Chakma", "mintuniranjanchakma@email.com"],
    ];

    const [countResult] = await db.execute(
      `select count(*) as count from users`,
    );
    const count = countResult[0].count;
    console.log("count:", count);

    if (count === 0) {
      await db.query("insert into users (name, email) values ?", [sampleUsers]);
    }

    const [users] = await db.execute(`select * from users`);
    console.log("users: ");
    users.forEach((user) => {
      console.log(`${user.id}. ${user.name} (${user.email})`);
    });

    const id = 3;
    const name = "Bharali Ranjan Chakma";
    const email = "bharaliranjanchakma@email.com";

    const [update] = await db.execute(
      `update users set name = ?, email = ? where id = ?`,
      [name, email, id],
    );

    if (update.affectedRows === 0) {
      console.log("No users was updated");
    } else {
      console.log("User was upadted", id);
    }

    const [userss] = await db.execute(`select * from users`);
    console.log("Userss: ");
    userss.forEach((user) => {
      console.log(`${user.id}. ${user.name} (${user.email})`);
    });
  } catch (error) {
    console.log(error);
  } finally {
    await db.end();
  }
}

main();
