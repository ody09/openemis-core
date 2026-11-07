<!DOCTYPE html>
<html lang="en">
<head>
    <?= $this->Html->charset() ?>
    <title>School Monitoring</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        html, body { background: #fff; }
        body { font-family: sans-serif; margin: 0; padding: 1.5rem; color: #222; overflow-x: hidden; }
        .sm-review { width: 100%; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: .4rem .6rem; text-align: left; }
        video, canvas { max-width: 100%; background: #111; }
        .status { margin: .75rem 0; padding: .5rem; background: #f4f4f4; }
        button { padding: .5rem 1rem; }
        label { display: block; margin: .5rem 0; }
        .sm-bar { display: flex; align-items: center; gap: .75rem; margin: -1.5rem -1.5rem 1.25rem; padding: .75rem 1.5rem; background: #006dcc; }
        .sm-bar a { color: #fff; text-decoration: none; font-weight: 700; border: 1px solid #fff; padding: .35rem .8rem; border-radius: 4px; }
        .sm-bar a:hover { background: #fff; color: #006dcc; }
        .sm-bar span { color: #fff; }
    </style>
</head>
<body>
    <div class="sm-bar">
        <a href="<?= h($backUrl ?? '/Institutions/Institutions/index') ?>">عودة</a>
        <span>School Monitoring</span>
    </div>
    <?= $this->Flash->render() ?>
    <?= $this->fetch('content') ?>
</body>
</html>
