import Database from "@tauri-apps/plugin-sql";

let db: Database | null = null;

export async function getDb(): Promise<Database> {
  if (db) return db;
  db = await Database.load("sqlite:existimer.db");
  await initDb(db);
  return db;
}

async function initDb(database: Database) {
  await database.execute(`
    CREATE TABLE IF NOT EXISTS settings (
      key TEXT PRIMARY KEY,
      value TEXT
    )
  `);
  await database.execute(`
    CREATE TABLE IF NOT EXISTS sessions (
      id TEXT PRIMARY KEY,
      start_time INTEGER NOT NULL,
      end_time INTEGER,
      duration INTEGER NOT NULL DEFAULT 0,
      pause_count INTEGER NOT NULL DEFAULT 0,
      pause_duration INTEGER NOT NULL DEFAULT 0,
      timer_type TEXT NOT NULL,
      target_duration INTEGER NOT NULL DEFAULT 0,
      is_completed INTEGER NOT NULL DEFAULT 0
    )
  `);
}

export async function getSetting(key: string): Promise<string | null> {
  const database = await getDb();
  const result = await database.select<{ value: string }[]>(
    "SELECT value FROM settings WHERE key = $1",
    [key]
  );
  return result.length > 0 ? result[0].value : null;
}

export async function setSetting(key: string, value: string): Promise<void> {
  const database = await getDb();
  await database.execute(
    "INSERT OR REPLACE INTO settings (key, value) VALUES ($1, $2)",
    [key, value]
  );
}

export interface Session {
  id: string;
  start_time: number;
  end_time: number | null;
  duration: number;
  pause_count: number;
  pause_duration: number;
  timer_type: "countdown" | "countup";
  target_duration: number;
  is_completed: number;
}

export async function saveSession(session: Session): Promise<void> {
  const database = await getDb();
  await database.execute(
    `INSERT OR REPLACE INTO sessions 
     (id, start_time, end_time, duration, pause_count, pause_duration, timer_type, target_duration, is_completed)
     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
    [
      session.id,
      session.start_time,
      session.end_time,
      session.duration,
      session.pause_count,
      session.pause_duration,
      session.timer_type,
      session.target_duration,
      session.is_completed,
    ]
  );
}

export async function getSessions(): Promise<Session[]> {
  const database = await getDb();
  return database.select<Session[]>("SELECT * FROM sessions ORDER BY start_time DESC");
}

export function generateId(): string {
  return crypto.randomUUID();
}