<?php
$mysqli = new mysqli("SERVER3", "user5", "M@gic456", "BWSdb.[dbo]");
if($mysqli->connect_error) {
  exit('Could not connect');
}

$sql = "SELECT COUNT(*) AS [Count] FROM ORDERS WHERE [Quote#] = ?";

$stmt = $mysqli->prepare($sql);
$stmt->bind_param("s", $_GET['q']);
$stmt->execute();
$stmt->store_result();
$stmt->bind_result($cid);
$stmt->fetch();
$stmt->close();

echo "<table>";
echo "<tr>";
echo "<th>COUNT</th>";
echo "<td>" . $cid . "</td>";
echo "</tr>";
echo "</table>";
?>