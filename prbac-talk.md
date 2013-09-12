% Parameterized Role-Based Access Control
% Kenneth Knowles
% September 24, 2013

Access Control
--------------

Can Kenn read `secrets.txt`?

Can ***person*** do ***action***? (on ***object***)


Formal Statements
-----------------

HasPermission("read", "Kenn", "secrets.txt")

`Permission(name="read", params={"user": "kenn", "file": "secrets.txt"})`


Unix Permissions as a little Proof
----------------------------------

```
$ ls -l secrets.txt
-rwxr-----  1 root  wheel   375 Sept 10 17:47 secrets.txt
```

HasPermission("read", "kenn", "secrets.txt") ?

1. "kenn" is in group "wheel"
2. "wheel" owns "secrets.txt"
3. The "group read" bit is true.

Thus Kenn can read it.


Unix Permissions as a little refutation
---------------------------------------

```
$ ls -l secrets.txt
-rwxr-----  1 root  wheel   375 Sept 10 17:47 secrets.txt
```

$HasPermission("read", "cory", "secrets.txt")$ ?

1. "cory" is not the owner.
2. "cory" is not in group "wheel".
3. The "all read" bit is false.

Thus Cory cannot read it.


Things such an inference system needs
--------------------------------------

It needs to be fast; these things happen all the time.

It needs to be as easy to refute as to prove.

It needs to be easy to understand!


The Logic of Unix Permissions
-----------------------------

1\. Atomic Permissions

 - OwnerRead(_file_)
 - OwnerWrite(_file_)
 - OwnerExec(_file_)
 - GroupRead(_file_)
 - GroupWrite(_file_)
 - GroupExec(_file_)
 - AllRead(_file_)
 - AllWrite(_file_)
 - AllExec(_file_)

(Deliberately being as verbose as the unix data representation)


The Logic of Unix Permissions
-----------------------------

2\. Ownership Info

 - Owner(_user_, _file_)
 - Group(_group_, _file_)



The Logic of Unix Permissions
-----------------------------

3\. Group Memberships
 
 - Member(_user_, _group_)


The Logic of Unix Permissions
-----------------------------

3\. Deduction Rules

 - Owner(_user_, _file_) $\wedge$ OwnerRead(_file_) $\Rightarrow$ HasPermission("read", _user_, _file_)
 - Member(_user_, _group_) $\wedge$ GroupRead(_file_) $\Rightarrow$ HasPermission("read", _user_, _file_)


The Logic of Unix Permissions
-----------------------------

Things to note:

 - Fixed set of hardcoded permissions.
 - Fixed set of deducation rules.
 - A user is zero ("all"), one ("owner"), or two ("group") degrees removed from a permisssion.

In particular, there is no interesting property of logic
leveraged. The most popular addition is transitivity.


