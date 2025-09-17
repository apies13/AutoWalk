<?php
date_default_timezone_set('Asia/Jakarta');

$keys = [];
$hwid = $_POST['hwid'] ?? '';

if ($hwid) {
    $today = date('Y-m-d');
    $stmt = $conn->prepare("SELECT key_code, expire_at, status, created_at FROM playerkeys WHERE hwid=? AND DATE(created_at)=? ORDER BY created_at DESC");
    $stmt->bind_param("ss", $hwid, $today);
    $stmt->execute();
    $result = $stmt->get_result();
    $keys = $result->fetch_all(MYSQLI_ASSOC);

    if (count($keys) == 0) {
        $newKey = 'SRN-FREE' . strtoupper(substr(bin2hex(random_bytes(3)), 0, 6));
        $status = 0; // Free
        $expire_at = date('Y-m-d H:i:s', time() + 1800);
        $created_at = date('Y-m-d H:i:s');

        $insert = $conn->prepare("INSERT INTO playerkeys (key_code, hwid, status, expire_at, created_at) VALUES (?, ?, ?, ?, ?)");
        $insert->bind_param("ssiss", $newKey, $hwid, $status, $expire_at, $created_at);
        $insert->execute();

        $keys[] = [
            "key_code" => $newKey,
            "expire_at" => $expire_at,
            "status" => $status,
            "created_at" => $created_at
        ];
    }

    // Hanya tampilkan key yang belum expired
    $keys = array_filter($keys, function($k) {
        return strtotime($k['expire_at']) > time();
    });
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Free Key - SIRENHub</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet" />
<style>
:root {
    --primary:#5271ff;
    --accent:#8c52ff;
    --gradient-main:linear-gradient(135deg,#16172D 0%,#1F1F3D 100%);
    --gradient-btn:linear-gradient(90deg,var(--accent) 0%,var(--primary) 100%);
    --gradient-btn-hover:linear-gradient(90deg,var(--primary) 0%,var(--accent) 100%);
    --surface:#1A1B32;
    --glass-bg:rgba(26,27,50,0.7);
    --glass-blur:blur(20px);
    --card-border:rgba(255,255,255,0.1);
    --text-light:#EAEBF2;
    --text-muted:#A0A3C2;
    --radius-md:12px;
    --radius-lg:18px;
    --shadow:0 10px 30px rgba(0,0,0,0.2);
    --transition:0.4s cubic-bezier(.4,0,.2,1);
}

* { box-sizing: border-box; margin:0; padding:0; }
body {
    background:var(--gradient-main);
    color:var(--text-light);
    font-family:'Inter',sans-serif;
    min-height:100vh;
    display:flex;
    flex-direction:column;
    align-items:center;
    padding-top:6rem;
}
body::before {
    content:"";
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background:url('https://media.hadesnetwork.online/abstract-bg-1.jpg') center/cover no-repeat;
    opacity:0.1;
    filter:blur(15px);
    z-index:-1;
}
a { text-decoration:none; color:inherit; }

header {
    position:fixed;
    top:0; left:0;
    width:100%;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0.8rem 1.5rem;
    background:var(--glass-bg);
    backdrop-filter:var(--glass-blur);
    border-bottom:1px solid rgba(255,255,255,0.1);
    z-index:1000;
}
header img { height:40px; }
header .btn {
    padding:0.5rem 1rem;
    border-radius:var(--radius-md);
    font-weight:600;
    background:var(--gradient-btn);
    color:#fff;
    transition:all 0.4s;
    font-size:0.9rem;
}
header .btn:hover { background:var(--gradient-btn-hover); }

main {
    width:100%;
    max-width:700px;
    padding:1rem;
}

h1 { font-size:2rem; margin-bottom:0.5rem; text-align:center; }
p { font-size:1rem; margin-bottom:1rem; text-align:center; color:var(--text-muted); }

.freekey-card {
    background:var(--glass-bg);
    backdrop-filter:var(--glass-blur);
    padding:2rem;
    border-radius:var(--radius-lg);
    border:1px solid var(--card-border);
    box-shadow:var(--shadow);
    display:flex;
    flex-direction:column;
    gap:1rem;
    width:100%;
}

input {
    padding:0.8rem 1rem;
    border-radius:var(--radius-md);
    border:1px solid rgba(255,255,255,0.2);
    background: rgba(255,255,255,0.05);
    color:#fff;
    font-size:1rem;
    width:100%;
}
button {
    padding:0.8rem 1rem;
    border:none;
    border-radius:var(--radius-md);
    font-weight:600;
    background:var(--gradient-btn);
    color:#fff;
    cursor:pointer;
    transition:all 0.4s;
    width:100%;
    font-size:1rem;
}
button:hover { background:var(--gradient-btn-hover); }

.key-card {
    background: var(--glass-bg);
    backdrop-filter: blur(20px);
    padding: 2rem;
    border-radius: var(--radius-lg);
    margin-top: 1.5rem;
    border: 1px solid var(--card-border);
    width: 100%;
}
.key-card h3 { margin-bottom: 1rem; text-align: center; }
.key-table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
}
.key-table th, .key-table td {
    padding: 0.8rem;
    border-bottom: 1px solid rgba(255,255,255,0.1);
}
.key-table th { color: var(--text-muted); }
.key-table td { color: var(--text-light); }
.copy-btn {
    padding: 0.4rem 0.8rem;
    border-radius: 8px;
    border: none;
    background: var(--primary);
    color: #fff;
    cursor: pointer;
    transition: 0.3s;
}
.copy-btn:hover { background: var(--accent); }

/* Responsive */
@media (max-width:600px){
    main { padding:1rem; max-width:100%; }
    h1 { font-size:1.5rem; }
    p { font-size:0.9rem; }
    .freekey-card, .key-card { padding:1.5rem; width:100%; }
    header { padding:0.5rem 1rem; }
    header .btn { padding:0.4rem 0.8rem; font-size:0.8rem; }
    .key-table th, .key-table td { padding: 0.5rem; font-size: 0.9rem; }
    .copy-btn { padding:0.3rem 0.6rem; font-size:0.85rem; }
}
</style>

</head>
<body>

<header>
    <img src="https://media.hadesnetwork.online/Favicon_Transparent-removebg-preview.png" alt="SIRENHub Logo">
    <a href="https://discord.gg/m5qdpgspRC" target="_blank" class="btn"><i class="fab fa-discord"></i> Join Discord</a>
</header>

<main>
    <h1>Get Your Free Cheat Key</h1>
    <p>Enter your HWID to generate and view your free keys for SIRENHub cheats. Each key is valid for 30 mins only.</p>
    <form method="POST" class="freekey-card">
        <input type="text" name="hwid" placeholder="Enter your HWID" required>
        <button type="submit"><i class="fas fa-key"></i> Generate Key</button>

        <?php if (!empty($keys)): ?>
        <div class="key-card">
            <h3>Your Keys</h3>
            <table class="key-table">
                <thead>
                    <tr>
                        <th>Key</th>
                        <th>Time Left</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <?php foreach ($keys as $k): 
                    $expireTimestamp = strtotime($k['expire_at']);
                ?>
                    <tr>
                        <td><?php echo htmlspecialchars($k['key_code']); ?></td>
                        <td data-expire="<?php echo $expireTimestamp; ?>" class="time-left">--:--</td>
                        <td><?php echo $k['status']==1?'Premium':'Free'; ?></td>
                        <td><button type="button" class="copy-btn" data-key="<?php echo htmlspecialchars($k['key_code']); ?>">Copy Key</button></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <script>
        // Countdown
        function updateCountdowns() {
            const now = Math.floor(Date.now() / 1000);
            document.querySelectorAll('.time-left').forEach(td => {
                const expire = parseInt(td.getAttribute('data-expire'));
                let diff = expire - now;
                if(diff <= 0){
                    td.textContent = "Expired";
                } else {
                    const minutes = Math.floor(diff / 60);
                    const seconds = diff % 60;
                    td.textContent = `${minutes}m ${seconds}s`;
                }
            });
        }
        setInterval(updateCountdowns, 1000);
        updateCountdowns();

        // Copy Key
        document.querySelectorAll('.copy-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const key = btn.getAttribute('data-key');
                navigator.clipboard.writeText(key).then(() => {
                    alert('Key copied: ' + key);
                });
            });
        });
        </script>
        <?php endif; ?>

    </form>
</main>

</body>
</html>
